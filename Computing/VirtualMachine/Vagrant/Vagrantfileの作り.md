# Vagrantfile の意味

Vagrantfile の意味が分からんのでちょっとしたまとめ

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.define "sample"
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "sample"
  config.vm.network "public_network", ip: "192.168.1.12"
#  config.vm.network "forwarded_port", guest: 8888, host: 8888

  config.vm.provider "virtualbox" do |v_box|
    v_box.name = "ubuntu14.04"
    v_box.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    v_box.cpus = 1
    v_box.memory = 1024
  end

  config.vm.provision "ansible_local" do |ansible|
    config.vm.synced_folder "./ansible", "/ansible"
    ansible.playbook = "/ansible/playbook.yaml"
    ansible.verbose = true
  end
end

```

## Vagrant Parameter

Vagarant のパラメータ解説

### config.vm.provider "privider_name"

Vagrant が使うホスト型 VM ソフトウェアの指定。  
Vagrant の世界では、実際に VM してくれるソフトウェアのことをプロバイダと呼ぶ。  
Vagrant はプロバイダ検出がかなり賢いので必要性は低い。

- VirtualBox を使う場合  
  config.vm.provider "virtualbox"
- VM Ware を使う場合  
  config.vm.provider "vmware_fusion"

### config.vm.define "vagrant_instance"

Vagrant が管理する VM のインスタンス名の設定。  
プロバイダが管理する名前ではないので注意。  
あくまで Vagrant の世界の話なので、その先は別に設定する必要がある。  
vagrant コマンドを使うときや vagrant コマンドの結果として出力される。

### config.vm.box = "ubuntu/trusty64"

公式：https://app.vagrantup.com/boxes/search

Vagrant に登録されているイメージの名前。  
Vagrant の世界では仮想化の元イメージを BOX と呼ぶ。

### config.vm.hostname = "host_name"

ホスト名を決めることができる。  
ログインしている環境を一目瞭然とするためにも環境名を付けると便利かもしれない。  
早い話が config.vm.define と同じ名前にしてろってこと（問題あるかは知らん）

### config.vm.network "network_type", ip: "xxx.xxx.xxx.xxx"

Vagrant には複数のネットワーク設定が存在する。  
絵を書いて解説したいが、メンドクサイのでとりあえず、[ここ](http://labs.septeni.co.jp/entry/20140707/1404670069)読めば OK

port forward する際の注意点として  
option の`host_ip: 'empty'`としてなければ`vagrant up`は通ってもネットワークが繋がらない。

### config.vm.synced_folder "host_path", "guest_path"

Vagrant はホストとゲストの間で共有ディレクトリを張ることが可能。  
ホストとゲストの順番には気を付けよう。

`vagrant up`のタイミングに有効化される。  
※もちろん、`vagrant reload`でも可。

オプションが結構あります。

| オプション名 | 設定値の型 |    デフォルトの設定値     | 内容                                 |
| :----------: | :--------: | :-----------------------: | :----------------------------------- |
|    create    |  boolean   |           false           | host_path を自動生成する             |
|   disabled   |  boolean   |           false           | 同期を無効化する                     |
|    group     |  boolean   | SSH ユーザー<br>(vagrant) | syced_folder の group を指定する     |
| mount_option |   array    |                           | mount コマンドのオプションを指定する |
|    owner     |   string   | SSH ユーザー<br>(vagrant) | synced_folder の owner を指定する    |
|     type     |   string   |     nfs<br>VirtualBox     | synced_floder の種類を指定する       |

### type について

共有フォルダは何のソフトウェアを使って実現するかを設定する。  
読めば読むほどメンドクサイので、VirtualBox が使えるなら大人しく使っておけ。

#### VirtualBox（Windows <--> macOS <--> Linux）

provider に VirtualBox を指定しているときのデフォルト値。  
VirtualBox の機能を使って共有するため、GuestAdditions のインストールが必要になる。

```bash:GuestAdditions_pluginのインストール方法
$ vagrant plugin install vagrant-vbguest
```

#### NFS（macOS <--> Linux）

VirtualBox 以外を Provider に設定した場合のデフォルト値
Windows との共有を張ることができない。

#### rsync（Windows <--> macOS <--> Linux）

[rsync](https://ja.wikipedia.org/wiki/Rsync)を使って共有する。  
`vagrant rsync`や`vagrant rsync-auto`のコマンドで同期する。  
<font color=red>ホストからゲストへの一方向に対する同期しか行わないので注意。</font>

当然、ホストとゲストの両方に`rsync`コマンドが必要になる。  
Windwos 環境では Cygwin/MinGW での導入が推奨されている。  
正直、Windows をかませる場合、くっそメンドウなので覚悟しろ。

#### SMB（Windows --> macOS / Linux）

Windows の機能[SMB](https://ja.wikipedia.org/wiki/Server_Message_Block)を使って共有する。  
<font color=red>Windows から macOS か Linux への一方向の共有しかできないので注意。</font>

## Virtual Box Parameter

Virtual Box のパラメータ解説

```Vagrantfile
config.vm.provider "virtualbox" do |v_box|
```

## Ansible-local Parameter

```Vagrantfile
config.vm.provision "ansible_local" do |ansible|
```

### config.vm.synced_folder "./ansible", "/ansible"

ansible は、他のサーバーに設定を流し込むソフトウェアである。  
そのため本来はは「ansible サーバー」と「構成したいサーバー」を用意する必要がある。  
ansible-local は構成したいサーバーに ansinle をインストールする設定である。  
この ansible を VM で実行するためには、ホストに用意した ansible 用の設定ファイル群を VM に認識させる必要がある。  
Vagrant では ansible ファイルを<font color=red>ホストとゲストが共有フォルダを張ること</font>で認識させる。

### ansible.playbook = "/ansible/playbook.yaml"

ansible の構成ファイル群のある共有ディレクトリを指定する。  
ansible-local は VM 上で動作するため<font color=red>VM 上のパスを指定しなければならない</font>。  
決して、ホスト側から見たファイルパスではないので注意すること。
