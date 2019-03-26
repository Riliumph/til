# Vagrantfileの意味
Vagrantfileの意味が分からんのでちょっとしたまとめ


```Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.define "Iris"
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "iris"
  config.vm.network "private_network", ip: "192.168.33.10"
#  config.vm.network "forwarded_port", guest: 8888, host: 8888
  config.vm.synced_folder "./", "/mnt/share"

  config.vm.provider "virtualbox" do |v_box|
    v_box.name = "ubuntu14.04-19-Iris"
    v_box.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    v_box.cpus = 1
    v_box.memory = 1024
  end
end
```

# Vagrant Parameter
Vagarantのパラメータ解説

## config.vm.provider "privider_name"
Vagrantが使うホスト型VMソフトウェアの指定。  
Vagrantの世界では、実際にVMしてくれるソフトウェアのことをプロバイダと呼ぶ。  
Vagrantはプロバイダ検出がかなり賢いので必要性は低い。  

- VirtualBoxを使う場合  
config.vm.provider "virtualbox"
- VM Wareを使う場合  
config.vm.provider "vmware_fusion"


## config.vm.define "vagrant_vm_name"
Vagrantが管理するVM名の設定。  
プロバイダが管理する名前ではないので注意。  
あくまでVagrantの世界の話なので、その先は別に設定する必要がある。  
vagrantコマンドを使うときやvagrantコマンドの結果として出力される。  

## config.vm.box = "ubuntu/trusty64"
公式：https://app.vagrantup.com/boxes/search  
  
Vagrantに登録されているイメージの名前。  
Vagrantの世界では仮想化の元イメージをBOXと呼ぶ。  

##  config.vm.hostname = "host_name"
ホスト名を決めることができる。  
ログインしている環境を一目瞭然とするためにも環境名を付けると便利かもしれない。  

## config.vm.network "network_type", ip: "xxx.xxx.xxx.xxx"
Vagrantには複数のネットワーク設定が存在する。  
絵を書いて解説したいが、メンドクサイのでとりあえず、[ここ](http://labs.septeni.co.jp/entry/20140707/1404670069)読めばOK

port forwardする際の注意点として  
optionの`host_ip: 'empty'`としてなければ`vagrant up`は通ってもネットワークが繋がらない。

## config.vm.synced_folder "host_path", "guest_path"
Vagrantはホストとゲストの間で共有ディレクトリを張ることが可能。  
ホストとゲストの順番には気を付けよう。  

`vagrant up`のタイミングに有効化される。  
※もちろん、`vagrant reload`でも可。

オプションが結構あります。  

|オプション名|設定値の型|デフォルトの設定値|内容|
|:---:|:---:|:---:|:---|
|create|boolean|false|host_pathを自動生成する|
|disabled|boolean|false|同期を無効化する|
|group|boolean|SSHユーザー<br>(vagrant)| syced_folderのgroupを指定する|
|mount_option|array||mount コマンドのオプションを指定する|
|owner|string|SSHユーザー<br>(vagrant)|synced_folderのownerを指定する|
|type|string|nfs<br>VirtualBox|synced_floderの種類を指定する|

## typeについて
共有フォルダは何のソフトウェアを使って実現するかを設定する。  
読めば読むほどメンドクサイので、VirtualBoxが使えるなら大人しく使っておけ。

### VirtualBox（Windows <--> macOS <--> Linux）  
providerにVirtualBoxを指定しているときのデフォルト値。  
VirtualBoxの機能を使って共有するため、GuestAdditionsのインストールが必要になる。  

```bash:GuestAdditions_pluginのインストール方法
$ vagrant plugin install vagrant-vbguest
```

### NFS（macOS <--> Linux）  
VirtualBox以外をProviderに設定した場合のデフォルト値
Windowsとの共有を張ることができない。

### rsync（Windows <--> macOS <--> Linux）  
[rsync](https://ja.wikipedia.org/wiki/Rsync)を使って共有する。  
`vagrant rsync`や`vagrant rsync-auto`のコマンドで同期する。  
<font color=red>ホストからゲストへの一方向に対する同期しか行わないので注意。</font>  
  
当然、ホストとゲストの両方に`rsync`コマンドが必要になる。  
Windwos環境ではCygwin/MinGWでの導入が推奨されている。  
正直、Windowsをかませる場合、くっそメンドウなので覚悟しろ。

### SMB（Windows --> macOS / Linux）
Windowsの機能[SMB](https://ja.wikipedia.org/wiki/Server_Message_Block)を使って共有する。  
<font color=red>WindowsからmacOSかLinuxへの一方向の共有しかできないので注意。</fonr>



# Virtual Box Parameter
Virtual Boxのパラメータ解説

```Vagrantfile
config.vm.provider "virtualbox" do |v_box|
```


