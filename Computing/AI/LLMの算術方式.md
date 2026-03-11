# LLMの算術方式

LLMは言語推論用の深層学習器である。  
つまり、算術機能はまったく持ち合わせていない。

しかし、「1+1=」といったプロンプトを渡すと数値を計算してくれる。  
これはどういう仕組みか？

## 生のLLMはどうしているか？

最近のLLMは色々と道具を使うようになってきているので一旦横においておく。  
[Phi](https://azure.microsoft.com/ja-jp/products/phi)などの生のLLMはどう計算しているのか？

### [「アルゴリズムなしの算術：言語モデルはヒューリスティクスの袋で数学を解く」](https://arxiv.org/abs/2410.21272)

Yaniv Nikankin, Anja Reusch, Aaron Mueller, Yonatan Belinkov  
大規模言語モデル（LLM）は、堅牢で汎化可能なアルゴリズムを学習して推論タスクを解いているのか、それとも学習データを単に記憶しているにすぎないのか？  
この問いを調べるために、私たちは算術推論を代表的なタスクとして用いる。  
因果分析を用いることで、基本的な算術ロジックに関するモデルの挙動の大部分を説明できるモデルの部分（回路）を特定し、その機能を調べる。  
個々の回路ニューロンのレベルにズームインすると、単純なヒューリスティクスを実装する少数の重要なニューロンからなる疎な集合が存在することを発見する。  
各ヒューリスティクスは、数値入力のパターンを識別し、対応する答えを出力する。  
私たちは、これらのヒューリスティックなニューロンの組み合わせこそが、正しい算術回答を生成するために用いられているメカニズムであると仮説を立てる。  
これを検証するために、各ニューロンを、たとえば「被演算子が特定の範囲にあると活性化するニューロン」のようなヒューリスティクスの種類に分類する。そして、これらのヒューリスティクスの種類の順不同の組み合わせこそが、算術プロンプトに対するモデルの精度の大部分を説明するメカニズムであることを見いだす。  
最後に、学習の初期段階において、このメカニズムが算術精度の主要な源として現れることを示す。  
総じて、複数のLLMにわたる実験結果は、LLMが算術を行う際に堅牢なアルゴリズムでも記憶でもなく、「ヒューリスティクスの袋」に依存していることを示している。  

### 前提条件

## 英語

Abstract
Do large language models (LLMs) solve reasoning tasks by learning robust generalizable algorithms, or do they memorize training data? To investigate this question, we use arithmetic reasoning as a representative task. Using causal analysis, we identify a subset of the model (a circuit) that explains most of the model’s behavior for basic arithmetic logic and examine its functionality. By zooming in on the level of individual circuit neurons, we discover a sparse set of important neurons that implement simple heuristics. Each heuristic identifies a numerical input pattern and outputs corresponding answers. We hypothesize that the combination of these heuristic neurons is the mechanism used to produce correct arithmetic answers. To test this, we categorize each neuron into several heuristic types—such as neurons that activate when an operand falls within a certain range—and find that the unordered combination of these heuristic types is the mechanism that explains most of the model’s accuracy on arithmetic prompts. Finally, we demonstrate that this mechanism appears as the main source of arithmetic accuracy early in training. Overall, our experimental results across several LLMs show that LLMs perform arithmetic using neither robust algorithms nor memorization; rather, they rely on a “bag of heuristics”.

1 Introduction
Do large language models (LLMs) implement robust reusable algorithms to solve tasks, or are they merely memorizing aspects of the training distribution? This distinction is crucial (Tänzer et al., 2022; Henighan et al., 2023): while memorization might suffice for limited problem sets, true algorithmic comprehension allows for generalization and efficient scaling to new problems.

Arithmetic reasoning provides a lens for this investigation, as it can be solved using various methods: learning known algorithms, developing novel approaches, or by memorizing vast quantities of input-output pairs. Thus, we ask the following: Do LLMs implement robust algorithms to correctly complete arithmetic prompts, similar to children learning vertical addition to add two numbers, or do LLMs merely memorize the arithmetic prompts that appear in their vast training data?

Previous studies have made progress in identifying arithmetic mechanisms in LLMs. Stolfo et al. (2023) and Zhang et al. (2024) have identified a subset of model components (a circuit) responsible for arithmetic calculations in several LLMs and characterized the information flow between them. Zhou et al. (2024) suggested that pre-trained LLMs use features in Fourier space to accurately answer addition prompts. However, Stolfo et al. (2023) and Zhang et al. (2024) stopped short of elucidating the mechanism implemented by the circuit they identified—a required feat to understand the trade-off between generalization and memorization in this task. Zhou et al. (2024) studied addition prompts in models that were fine-tuned on arithmetic data. Their findings regarding Fourier features are significant, but we claim these represent only a part of a more complex mechanism. Our work aims to bridge these gaps: we investigate how the arithmetic circuit works qualitatively—and specifically, whether it implements a mathematical algorithm or memorizes arithmetic training data.

To do so, we reverse-engineer the arithmetic mechanism applied by LLMs. We use causal analysis to examine their arithmetic circuits, focusing on individual neurons within the circuit responsible for generating the correct answer. Our analysis reveals that a sparse subset of neurons is sufficient for accurate responses, with each neuron implementing a distinct heuristic. Each heuristic fires for a specific pattern in input operands or in their combination, and some increase the logits of relevant result tokens accordingly. For instance, one heuristic (Figure 1b) increases logits of tokens between 150 and 180 for subtraction prompts whose answer falls within this range. By examining these neurons, we classify each into one or more heuristic types. For example, the mentioned neuron (Figure 1b) falls within the type of result-range heuristics, which promote continuous value ranges. We discover that successful prompt completion relies on a combination of several unrelated heuristic types, forming a “bag of heuristics” approach. This finding suggests that LLMs may not be employing a single, cohesive algorithm for arithmetic reasoning, nor are they memorizing all possible inputs and outputs; rather, they deploy a collection of simpler rules and patterns.

We investigate if the bag of heuristics emerges as the primary arithmetic mechanism from the onset of training, or whether it overrides an earlier mechanism. To do that, we analyze how the heuristics evolve over the course of training. We show arithmetic heuristics appear throughout the model training, gradually converging towards the heuristics observed in the final checkpoint. Furthermore, we provide evidence that the bag of heuristics mechanism explains most of the model’s behavior even in early stages, indicating it is the main mechanism used for solving arithmetic prompts.

We contribute by providing a high-resolution understanding of the mechanism that LLMs use to answer arithmetic prompts. We (i) show pre-trained LLMs implement a “bag of heuristics” approach, (ii) investigate when and why this mechanism fails to generalize, and (iii) discover how it emerges across training. This allows us to better understand the source of current capabilities and limitations of LLMs in arithmetic reasoning—a finding that could apply to additional reasoning tasks.

Refer to caption
Figure 1:Bag of heuristics visualization. We show that transformer LLMs solve arithmetic prompts by combining several unrelated heuristics, each activating according to rules based on the input values of operands, and boosting the logits of corresponding result tokens. These heuristics are manifested in single MLP neurons in mid to late layers.
2Arithmetic circuit discovery
In transformer-based LLMs, a circuit (Elhage et al., 2021) refers to a minimal subset of interconnected model components (multi-layer perceptrons (MLP) or attention heads) that perform the computations required for a specific task. We locate, and later analyze, the circuit responsible for arithmetic calculations.

2 1Circuit discovery and evaluation

Refer to caption(a)
Refer to caption(b)

Figure 2:Llama3-8B arithmetic circuit discovery results. (a): Few attention heads have a high effect on arithmetic prompts. Most MLPs take part in the computation. The first MLP noticeably affects operand and operator positions, while mid- and late-layer MLPs influence the final position. (b): The arithmetic circuit in Llama3-8B. The attention heads project token information to the last position, where the middle- and late-layer MLPs promote the logits for the correct answer.

Models and Data

We analyze four LLMs: Llama3-8B/70B (Dubey et al., 2024), Pythia-6.9B (Biderman et al., 2023), and GPT-J (Wang & Komatsuzaki, 2021). For each, we locate and analyze the circuit responsible for arithmetic calculations. We focus on Llama3-8B in the main paper and report similar results for the additional models in Appendix I. We use pre-trained models without fine-tuning them on arithmetic prompts, as our goal is to uncover the mechanisms induced by typical language model training. Each model tokenizes positive numbers as a single token, up to some limit; e.g., in Llama3-8B, numbers in $[0, 1000]$ are tokenized to a single token. To locate the arithmetic circuit, we use two-operand arithmetic prompts with Arabic numerals and the four basic operators (+,−,×,÷), such that each prompt has four tokens:o​p​1, the operator,o​p​2, and the “=” sign. We ample a list of 100 prompts per operator for circuit discovery, and an identical amount for evaluation. Each prompt is chosen so that both its operands and result will be tokenized to a single token; e.g., in Llama3-8B, the operands and result must be between 0 and 1,000. Unlike previous studies (Stolfo et al., 2023), we do not use in-context prompting, to ensure the circuit does not include any component not directly linked to arithmetic calculations. To reduce noise and ensure the circuits only contain components responsible for correct arithmetic completions, we only use prompts that are correctly completed by the model, similar to previous studies (Wang et al., 2022; Prakash et al., 2024). Throughout the paper, the prompt “226−68=” is used as a running example.

Method

To locate the circuit components, we conduct a series of activation patching experiments (Vig et al., 2020) that allow us to assess the importance of each MLP and attention head at each sequence position. Each experiment involves sampling a prompt p with result $r$ from the dataset (for example, “226−68=”), and sampling a random counterfactual prompt $p$that leads to a different result $r′$ (for example, “21+17=”). After pre-computing the activations of the model for the counterfactual prompt p′, we introduce the prompt $p$ to the model. We intervene on (“patch”) the computation, which means we replace the activation of a single MLP layer or attention head with its pre-computed activation for $p′$. Following Stolfo et al. (2023), we observe how this intervention affects the probabilities of both answer tokens, $r$ and $r′$, by measuring the following:

$$
E​(r,r′)=1/2​[ℙ∗​(r′)−ℙ​(r′)/ℙ​(r′) + ℙ​(r)−ℙ∗​(r)/ℙ∗​(r)] (1)
$$

where $ℙ$ and $ℙ∗$ are the pre- and post-intervention probability distributions, respectively. The two summands in Equation 1 increase if patching raises the probability of $r′$ or decreases the probability of $r$, respectively. High effect for an intervention on a component indicates its high importance in prompt calculation. The effect is averaged across prompts and measured separately per component.

Results

The patching results, shown in Figure 2(a), reveal that the MLP layers affect the output probabilities more than the attention heads. The first MLP affects the representation at the operator and operand positions (see Section B.1), while middle- and late-layer MLPs exhibit a strong effect at the final position, likely reflecting their role in predicting the answer token in that position (further discussed in Section 2.2). Figure 2(a) also shows that very few attention heads are important to the circuit. Each such attention head copies information from a single position (either an operand or operator position) to the final position (see Section B.2). Figure 2(b) summarizes the information flow within the circuit, consistent in structure with prior work (Stolfo et al., 2023).

To evaluate the circuit $𝐜$, we measure its faithfulness (Wang et al., 2022), the proportion of the full model’s behavior on arithmetic prompts that can be explained solely by the circuit. To measure faithfulness, we first pre-compute mean activations for each model component (in each position) across all arithmetic prompts. We then intervene on the evaluation prompts by replacing non-circuit component activations with their means. To quantify performance, we measure $NL⁡(𝐜)$, the logit of the correct answer token normalized by he maximal logit, as a proxy for accuracy, when mean-ablating all components not in the circuit 𝐜. The circuit’s faithfulness is calculated as:

$$
F⁡(𝐜)=NL⁡(𝐜)−NL⁡(∅)NL⁡(𝐌)−NL⁡(∅)(2)
$$

where $𝐌$ is the entire model and $NL⁡(𝐌)$ is the normalized correct-answer logit when no component is ablated (always 1.0 for correctly completed prompts).
$NL⁡(∅)$ is the normalized correct answer logit when all components are mean-ablated. This formula normalizes faithfulness to a $[0.0, 1.0]$ range.
The circuit achieves a high faithfulness of 0.96 on average across the four arithmetic operators; i.e., the circuit accounts for 96% of the entire model’s performance. We can therefore conclude that the components identified in this section comprise the arithmetic circuit, and explain most of the model’s accuracy for arithmetic prompts. See Appendix A for results across various circuit sizes, and a discussion of Pareto-optimality with respect to faithfulness and size.

2.2Identifying answer-promoting components

Refer to caption
Figure 3:Answer token probe accuracy. The linear probes are successful in extracting the correct answer from the final position, starting at layer 16.
To understand the mechanism implemented by the circuit to promote the correct answer, we first search for the specific circuit components that increase the probability of the correct answer. For this, we employ linear probing (Belinkov, 2022). For each layer l and sequence position p, we train a linear classifier
$f_{l,p}:ℝ^d→ℝ^{1000}$ (where d is the dimension of each layer’s output representation) using a training set of correctly completed arithmetic prompts. We pass these prompts through the model and calculate the output representation
$h_{l,p}∈ℝ^d$ at layerl and positionp for each prompt. The classifier $f_{l,p}$ receives $h^{l,p}$ as input, and outputs a probability istribution ver the 1,000 possible arithmetic answers. The classifier $f_{l,p}$ is evaluated on a separate test set of correctly completed prompts, showing to what extent the correct answer can be extracted from the output representation at layer
$l$ and position $p$.

We find that the answer can only be extracted with high accuracy from the final position (Figure 3), after the token representation is processed by the later layers of the model, starting from layer $l=16$. Given that the arithmetic circuit contains only MLPs in these layers (Figure 2), this suggests that these MLPs in layers $[16,32]$ are the components that write the correct answer into the representation at the last position. The following section zooms into these middle- and late-layer MLPs, and presents evidence for the role they play in generating the correct answer— specifically, in how they promote the correct answer token through a combination of many independent arithmetic heuristics.

3 MLP neurons implement arithmetic heuristics

3.1 Decomposing circuit MLPs to individual neurons

Refer to caption(a) We intervene on each neuron in MLP layer $l=17$. Few neurons in this and other middle- and late-layer MLPs have a high effect on arithmetic prompts.

Refer to caption(b) We measure the faithfulness when including only a fraction of high-effect neurons in the circuit. This circuit achieves high faithfulness.

Figure 4:Analyzing effect of individual circuit MLP neurons. Our results demonstrate that a small amount of neurons is required to correctly predict the result.

Having shown that the model generates the arithmetic answer in middle- and late-layer MLPs at the final position $p=4$, we zoom in on these MLPs and their calculations at this position to investigate the implemented mechanism. The MLP at layer $l$ can be escribed by the following equation:

$$
𝐡_{o​u​t}^{l} = MLP_{i​n}⁡(𝐡_{i​n}^{l}) ⋅ 𝐖_{o​u​t}^{l} = 𝐡_{p​o​s​t}^{l} ⋅ 𝐖_{o​u​t}^{l} = ∑_{n=0}^{d_{m​l​p}} 𝐡_{p​o​s​t}^{l,n} ​𝐯_{o​u​t}^{l,n} (3)
$$

where $𝐡_{in}^{l}$,$𝐡_{ou​t}^{l}∈ℝ^d$ are the input and output representations of the MLP at layer $l$, respectively. $𝐡_{p​o​s​t}^{l} ∈ ℝ^{d_{m​l​p}} is the output of the up-projection of the MLP, where we define the $n^{th}$ value $𝐡_{p​o​s​t}^{l,n}∈ℝ$ as a neuron. $𝐖_{o​u​t}^{l}∈ℝ^{d_{m​l​p}×d}$ is the output projection matrix, and $𝐯_{ou​t}^{l,n}$ is its $n^{th}$ row vector. Biases are omitted. By expressing the output representation $𝐡_{o​u​t}^{l}$ as a linear combination of row vectors
$𝐯_{o​u​t}^{l,n}$ and their corresponding neuron activations $𝐡_{p​o​s​t}^{l,n}$, we can identify the neurons that most affect the completion of arithmetic prompts.

To measure the effect of each neuron $𝐡_{p​o​s​t}^{l,n}$, we perform activation patching experiments on individual neurons (as described in Section 2.1), and measure the average effect across prompts. We observe that very few neurons have a high effect; an example for layer $l=17$ is shown in Figure 4(a). Additionally, we notice the neurons with the highest effect are different between operators. In fact, roughly 45% of the important neurons for each operator are unique (Appendix D). Thus, when analyzing the circuit at the neuron level, we analyze it as 4 separate circuits—one for each arithmetic operator. We hypothesize that for each operator, the highest-effect neurons are sufficient to explain most of the model’s arithmetic behavior. To verify this, we measure the faithfulness of the arithmetic circuit when mean ablating non-circuit components and lower effect MLP neurons in middle- and late-layer MLPs. The results (Figure 4(b)) confirm that only 200 neurons (roughly 1.5%) per layer are needed to achieve high faithfulness and correctly compute arithmetic prompts.

3.2 MLP neurons act as memorized heuristics
To understand how the top-200 middle- and late-layer important MLP neurons contribute to the generation of correct answers, we view them as key-value memories (Geva et al., 2021). In this view, the input to each MLP layer $𝐡_{i​n}^{l}$ is multiplied by a key (a row vector in the MLP input weight matrix) to generate a neuron activation𝐡p​o​s​tl,n that determines how strongly does a value (a row vector $𝐯_{o​u​t}^{l,n}$ in the MLP output weight matrix) gets written to the MLP output (Equation 3). Geva et al. (2021) demonstrated that keys correspond to specific topics or n-grams, triggering high neuron activations when these are given as input, and their corresponding values represent tokens that can serve as appropriate completions for these topics or n-grams. Building on this insight, we hypothesize that (i) in arithmetic contexts, keys correspond to numerical patterns, e.g., a neuron might activate strongly when both operands in an arithmetic operation are odd numbers; and (ii) the associated value vectors encode numerical tokens that represent plausible answers to the key patterns.

To test the first hypothesis, we investigate the activation pattern of the top-
200
 neurons in each layer. For each neuron
l
,
n
, we plot the activations
𝐡
p
​
o
​
s
​
t
l
,
n
 (at position
p
=

4
) as a function of operand values, separately for each operator. We find that many neurons in the arithmetic circuit exhibit distinct, human-identifiable patterns. For instance, in “
226
−
68
=

”, neuron
𝐡
p
​
o
​
s
​
t
24
,
12439
 shows high activation values for subtraction prompts with results between
150
 and
180
 (Figure 1). Additional examples are provided in Appendix J.

To verify the second hypothesis, we check whether the tokens embedded in the value vectors of the top neurons relate to their activation patterns. Using the Logit Lens (nostalgebraist, 2020), a method of projecting a vector
𝐯
∈
ℝ
d
 onto a probability distribution over the vocabulary space
ℙ
d
v
​
o
​
c
​
a
​
b
, we project each value vector
𝐯
o
​
u
​
t
l
,
n
 to find the numerical tokens whose logits are highest. This reveals two distinct patterns: First, in some neurons, the activation pattern depends on both operands and the value vector encodes the expected result of the arithmetic calculation (Figure 1b,c). We term such neurons direct heuristics. Second, in neurons where the activation pattern depends on a single operand, the value vectors often encode features for downstream processing, rather than the result tokens directly (Figure 1a). We term such neurons indirect heuristics. Next, we demonstrate how these heuristic neurons combine to produce correct arithmetic answers.

4Arithmetic prompts are answered with a bag of heuristics
Refer to caption
Figure 5:Heuristic pattern examples. Each heatmap is the activation pattern of an example neuron, implementing a specific heuristic type. Within the heatmap, each pixel at location (
o
​
p
1
,
o
​
p
2
) represents the activation strength of the neuron under the addition prompt “
o
​
p
1
+
o
​
p
2
=

”.
Observing the example prompt, “
226
−
68
=

”, we have shown that it satisfies the pattern of several heuristic neurons, where each such neuron slightly increases the logit of the result token,
r
=

158
 (Figure 1). These small increases combine to promote the correct token as the final answer. We hypothesize that a combination of independent heuristics—termed a bag of heuristics—emerges across arithmetic prompts, comprising the mechanism used by the model to produce correct answers.

4.1Classifying neurons to heuristic types
To present evidence for the causal effect of the bag of heuristics on generating correct answers, we first systematically classify neurons into heuristic types. Through manual observation of key activation patterns, we identify several categories of human-identifiable heuristics, exemplified in Figure 5, and further detailed in Appendix E. To determine if a neuron
n
 at layer
l
 implements a specific heuristic, we examine the intersection between the prompts that activate the neuron and the prompts expected to be activated for this heuristic. A visual example of this procedure is shown in Figure 6. An automated algorithm of this approach is described in Appendix F.

Refer to caption
Figure 6:Neuron to heuristic matching example. (a) Measure the value of
h
p
​
o
​
s
​
t
29
,
2850
 for each operand pair
(
o
​
p
1
,
o
​
p
2
)
, using the chosen operator (addition). (b) Calculate the logits of numerical tokens embedded in
v
o
​
u
​
t
29
,
2850
, using Logit Lens (nostalgebraist, 2020). (c) Convert the logits vector to a 2D pattern, where the cell in index
(
o
​
p
1
,
o
​
p
2
)
 is the logit of the result token of applying the operator to
(
o
​
p
1
,
o
​
p
2
)
 (i.e.
o
​
p
1
+
o
​
p
2
). (d) Multiply both patterns element-wise, to get the effective logit contribution of the neuron to the correct answer token for each prompt. (e) Extract the prompts that activate the neuron the most from the activation pattern. (f) Create a list of prompts associated with the tested heuristic. (g) Measure the intersection between the two prompt lists. If this intersection is larger than a threshold (we use
t
=

0.6
), the neuron is said to implement the heuristic.
We apply this algorithm to each pair of important MLP neuron
n
 in layer
l
 and heuristic
H
. Through this method, we classify as arithmetic heuristics 91% of the 3,200 top neurons for each operator (200 per layer across 16 layers). Manual inspection of neurons that fail to classify into one of the defined heuristics reveals patterns that are not clearly identifiable (Appendix J).

4.2Heuristic types are combined to answer arithmetic prompts
Following the classification of the important neurons in each middle- and late-layer MLP into one or several heuristic types, we provide evidence that the bag of heuristics is the primary mechanism the model uses to correctly answer arithmetic prompts. We show this through two ablation experiments.

Knocking out neurons by heuristic type.
We now verify that the neurons in each heuristic type contribute to the accuracy of associated prompts by knocking out entire heuristic types and observe the resulting changes in model accuracy. We define a prompt as associated with a heuristic if and only if its components meet the conditions specified by that heuristic. (For instance, the example prompt “
226
−
68
=

” is associated with the heuristic “
o
​
p
​
1
≡
0
(
mod
2
)
”.) For each heuristic, we sample two sets of
100
 correctly completed prompts each, one containing prompts associated with the heuristic and the other containing prompts not associated with that heuristic. For each heuristic, we knock out all neurons classified into it (by setting each
h
p
​
o
​
s
​
t
l
,
n
 activation to zero) and then remeasure the accuracy on both sets of prompts. We expect a higher decrease in accuracy on the associated prompts, since we claim each heuristic is causally linked only to its associated prompts.

The results (Figure 7) show that ablating neurons of a specific heuristic causes a significant accuracy drop on associated prompts, more than on not associated prompts, on average. This confirms the causal importance of heuristic neurons in promoting correct answer logits specifically in prompts that are associated with their heuristic type, verifying the targeted functional role of these heuristics.

However, the ablation does not result in a complete accuracy drop; it causes an average drop of 29% out of 95% average pre-ablation accuracy. We find two reasons for this. First, some heuristics have low recall: they do not apply to all associated prompts as they should (see Appendix J). Second, each prompt relies on several unrelated heuristic types, so even when one is ablated, others still contribute to increasing the correct answer’s logit. In the following ablation experiment, we verify that this interplay of heuristics provides a fuller image than focusing on one heuristic at a time.

Refer to caption
Figure 7: For each heuristic, we measure the accuracy of 100 correctly completed prompts associated with a heuristic (blue) and 100 correctly completed prompts not associated with the heuristic (yellow), after ablating that heuristic’s neurons. The heuristics are sorted by the accuracy drop induced on associated prompts. Across most heuristics, ablating heuristic neurons causes a larger decrease in accuracy in prompts associated with that heuristic than in not associated prompts.
Knocking out neurons by prompt.
To provide further evidence that the bag of heuristics is causally linked to correct arithmetic completion, we conduct a second ablation experiment. For each correct prompt, we identify the heuristic types that should affect it based on its operands and ground truth result. We then ablate the neurons with the highest classification scores (Section 4.1) in these heuristics, up to a certain neuron count, and check if the model’s completion changes.

The results (Figure 8) show that ablating neurons from associated heuristics significantly drops the model’s accuracy, much more than the accuracy drop caused by ablating the same number of randomly chosen neurons from unassociated heuristics. This demonstrates that we can identify the neurons important to a given prompt solely based on its associated heuristics. This also indicates a causal link between the neurons belonging to several heuristics and the prompt’s correct completion. This supports our bag of heuristics claim: each heuristic only slightly boosts the correct answer logit, but combined, they cause the model to produce the correct answer with high probability.

Refer to caption
Figure 8:Knocking out neurons that implement heuristics associated with each prompt (full lines) leads to a greater decrease in accuracy than knocking out the same number of neurons whose heuristics are not associated with each prompt (dashed lines). This effect occurs across model sizes.
4.3Failure modes of the bag of heuristics
The bag of heuristics mechanism employed in Llama3-8B does not generalize perfectly: it fails to achieve perfect accuracy across all arithmetic prompts (Appendix H). This limitation contrasts with the theoretical robustness of a genuine algorithmic approach. Here, we aim to elucidate the specific failures of this mechanism, focusing on why it falters for some prompts.

We hypothesize that the bag of heuristics mechanism completes prompts incorrectly in two ways. (1) The “bag” might not be big enough; i.e., a prompt might lack sufficient associated neurons. (2) the heuristics might have imperfect recall (e.g., a neuron that fires for most prompts where the first operand is even, but does not fire for the prompt “
226
−
68
=

”) or have low logits for the correct answer token in the value vectors.

Refer to caption
Figure 9: The model’s failures can be explained by a lower total logit contribution of the heuristic neurons to the correct answers.
To test these hypotheses, we randomly sample 50 correctly completed and 50 incorrectly completed prompts. To test hypothesis (i), we count the number of heuristic neurons associated with each prompt. We find that on average, incorrect prompts have more heuristic neurons associated with them than correct prompts. Therefore, we find no support for this hypothesis. To check hypothesis (ii), we calculate the total contribution of all heuristic neurons to the logit of the correct answer for each prompt. This measurement considers both the specific activation of each neuron for the prompt, as well as the logit of the correct answer token embedded in each neuron’s value vector. On average, there is indeed a slight advantage in the total logit contribution for correct prompts over incorrect prompts (Figure 9). This suggests that the primary reason for the bag of heuristics failure on certain prompts is poor promotion of correct answer logits, rather than a lack of heuristics.

5Tracking heuristics development across training steps
Refer to caption
(a)
Refer to caption
(b)
Refer to caption
(c)
Figure 10:Heuristic analysis across Pythia-6.9B training checkpoints. (a) The percentage of heuristic neurons from the last checkpoint that also appear in previous checkpoints increases over training, revealing a gradual creation of the bag of heuristics. (b) The heuristic neurons that are mutual with the last checkpoint (full line) explain most of the total heuristic behavior (dashed line) at each checkpoint. Thus, the heuristics that disappear across training are less important to the model. (c) Ablating specific heuristic neurons heavily drops the model’s accuracy across all training checkpoints. This suggests arithmetic accuracy primarily stems from heuristics, even in early stages.
Does the bag of heuristics emerge as the primary arithmetic mechanism from the onset of training, or does it override an earlier, different mechanism that initially drives arithmetic performance? We conduct an analysis of heuristic development across the training trajectory of the Pythia-6.9B model (Biderman et al., 2023), due to the public availability of its training checkpoints. Specifically, we analyze the model at its final checkpoint (143K steps) and at 10K-step intervals down to 23K steps. The 23K checkpoint is the earliest checkpoint showing good arithmetic performance; Thus, we begin our analysis at this checkpoint. To guide this analysis, we aim to answer three sub-questions:

When do the final heuristic neurons first appear? We examine when each heuristic neuron from the final checkpoint first appears during training. For each neuron classified into a particular heuristic type, we check if the same neuron gets classified into the same heuristic in earlier checkpoints. Averaging this measure across all heuristic types and operators provides insight into when the final heuristics initially appear during training. We observe (Figure 10(a)) that the model develops its final heuristic mechanism gradually across training, starting from an early checkpoint.

Do additional heuristic neurons exist mid-training? Next, for each mid-training checkpoint, we investigate whether its heuristic neurons that are mutual with the final checkpoint make up the entire heuristic mechanism in that checkpoint, or whether other heuristics exist that later become vestigial. We examine the faithfulness (Section 2.1) of the arithmetic circuit at each checkpoint—once when including only the neurons mutual with the final checkpoint, and once when including all heuristic neurons in that checkpoint. The difference between these two measurements gives us an estimate of the importance of the mutual heuristics. Using this metric, we observe that these final heuristics explain most of the circuit performance for each intermediate checkpoint: they account for an average of 79% of the total heuristics’ contribution to accuracy at each checkpoint. This indicates that, while other non-mutual heuristics exist in each checkpoint, these are less important to the circuit’s accuracy and slowly become vestigial as the circuit converges to its final form.

Does a competing arithmetic mechanism exist mid-training? Finally, we determine if the heuristics appear as the main arithmetic mechanism from early on in training, or if they co-exist with an unrelated mechanism that becomes vestigial in later checkpoints. We repeat the prompt-guided neuron knockout experiment (Section 4.2) for each checkpoint; i.e., in each checkpoint, we sample
50
 correctly completed prompts for each operator. For each prompt, we ablate
5
,
10
, and
25
 heuristic neurons associated with the prompt in that checkpoint. We test if this targeted ablation significantly impairs the model’s accuracy, even in earlier stages of training, and compare this to a baseline, where we ablate a similar amount of randomly chosen heuristic neurons. The results (Figure 10(c)) demonstrate that removing any amount of neurons from heuristics associated with a prompt substantially reduces the model’s accuracy on these prompts even at earlier checkpoints, much more than ablating a random set of important neurons. We also observe that ablating
25
 heuristic neurons per layer is enough to cause near-zero accuracy in all stages of training. This finding asserts that the causal link between a prompt’s associated heuristics and its correct completion exists throughout training.

6Related work
Mechanistic interpretability (MI) aims to reverse-engineer mechanisms implemented by LMs by analyzing model weights and components. Causal mediation techniques (Pearl, 2001) like activation patching (Vig et al., 2020; Geiger et al., 2021), path patching (Wang et al., 2022), and attribution patching (Nanda, 2022; Syed et al., 2023; Hanna et al., 2024b) allow localizing model behaviors to specific model components. Other studies have also presented techniques to explain the effect of specific weight matrices on input tokens (Elhage et al., 2021; Dar et al., 2023), or to analyze activations (nostalgebraist, 2020; Geva et al., 2021). Many studies have aimed to use these techniques to reverse-engineer specific behaviors of pre-trained LMs (Wang et al., 2022; Hanna et al., 2024a; Gould et al., 2024; Hou et al., 2023). We leverage MI techniques to reverse-engineer the arithmetic mechanisms implemented by pre-trained LLMs and explain them at a single-neuron resolution.

Memorization and generalization in LLMs.
Whether models memorize training data or generalize to unseen data has been extensively studied in deep learning (e.g., Zhang et al., 2021) and specifically in LLMs (Tänzer et al., 2022; Carlini et al., 2023; Antoniades et al., 2024), but not many studies have observed this question through the lens of model internals. Among those that do, Bansal et al. (2022) attempt to predict this trade-off by observing the diversity of internal activations; Dankers & Titov (2024) show memorization in language classification tasks is not local to specific layers, and Varma et al. (2023) explain grokking using memorizing and generalizing circuits. We use this lens to observe how model internals operate in arithmetic reasoning—a task that could theoretically be solved either through extensive memorization or by learning a robust algorithm. Concurrent work (jylin et al., 2024) has shown that a LM trained to predict legal board game moves (Li et al., 2022) does so by implementing many heuristics. While heuristics would suffice to robustly predict legal moves in a board game setting, we find that the extent to which LLMs rely on heuristics is greater than prior work suggests: sets of heuristics are used to accomplish even generic tasks like arithmetic, where no heuristic is likely to generalize to all possible results.

Arithmetic reasoning interpretability.
Recent studies on how LMs process arithmetic prompts (Stolfo et al., 2023; Zhang et al., 2024) reveal the general structure of arithmetic circuits, but do not fully explain how they combine operand information to produce correct answers. Our research bridges this gap by revealing the mechanism used for promoting the correct answer. Some studies show the emergence of mathematical algorithms for modular addition (Nanda et al., 2023; Zhong et al., 2024; Ding et al., 2024) and binary arithmetic (Maltoni & Ferrara, 2023) in simple, specialized toy LMs, but it is unclear if these findings extend to larger, general-purpose LMs or other operators. In pre-trained LLMs, Zhou et al. (2024) found that Fourier space features are used for addition. However, we claim this is only a partial view, as many additional types of features and heuristics relying on these features are involved in calculating answers across arithmetic operations. In this work, we give a wide view of these heuristics and how they combine to generate arithmetic answers.

7Conclusions
Do LLMs rely on a robust algorithm or on memorization to solve arithmetic tasks? Our analysis suggests that the mechanism behind the arithmetic abilities of LLMs is somewhere in the middle: LLMs implement a bag of heuristics—a combination of many memorized rules—to perform arithmetic reasoning. To reach this conclusion, we performed a set of causal analysis experiments to locate a circuit, i.e., a subset of model components, responsible for arithmetic calculations. We examined the circuit at the level of individual neurons and pinpointed the arithmetic calculations to a sparse set of MLP neurons. We showed that each neuron acts as a memorized heuristic, activating for a specific pattern of inputs, and that the combination of many such neurons is required to correctly answer the prompts. In addition, we found that this mechanism gradually evolves over the course of training, emerging steadily rather than appearing abruptly or replacing other mechanisms.

Our results, showing LLMs’ reliance on the bag of heuristics, suggest that improving LLMs’ mathematical abilities may require fundamental changes to training and architectures, rather than post-hoc techniques like activation steering (Subramani et al., 2022; Turner et al., 2023). Additionally, the evolution of this mechanism across training indicates that models learn these heuristics early and reinforce them over time, potentially overfitting to early simple strategies; it is unclear if regularization can improve this, and this is a possible avenue for future research.

8Limitations and discussion
Interpretability work is often fundamentally limited by human biases. As researchers, we often impose human abstractions onto models, whereas the goal of interpretability is to understand the abstractions that models learn and apply in a way that we can understand. Our work is also subject to this limitation, namely with respect to the definition of heuristic types: We define heuristic abstractions based on our human-identifiable definitions. A possible improvement would be to develop a method to identify these abstractions without human bias. Another important detail is that our analysis focuses on LLMs that combine digits in tokenization. That is, every token can contain more than one digit. The robust algorithms used by humans depend on our ability to separate larger numbers to single digits. Thus, a similar analysis might lead to different conclusions for models that perform single-digit tokenization.

Acknowledgments
We are grateful to Dana Arad and Alessandro Stolfo for providing feedback for this work. This research was supported by the Israel Science Foundation (grant No. 448/20), an Azrieli Foundation Early Career Faculty Fellowship, and an AI Alignment grant from Open Philanthropy. AM is supported by a postdoctoral fellowship under the Zuckerman STEM Leadership Program. AR is supported by a postdoctoral fellowship under the Azrieli International Postdoctoral Fellowship Program and the Ali Kaufman Postdoctoral Fellowship. This research was funded by the European Union (ERC, Control-LM, 101165402). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Research Council Executive Agency. Neither the European Union nor the granting authority can be held responsible for them.
