# Assignment

## SQL
Please look at **customer_retention.sql** file. I have added my comments around few SQL clauses.

## Modelling
I have added many markdown comments in the jupyter notebook **modelling.ipynb** that cover (a) to (d) parts of the question. Part (e) is covered below:

Potential issues to deploy model into productions:

- Data ingestion - a production model won’t read data from a csv and should ideally be read from a data warehouse. Appropriate changes will be required to handle this matter.

- Re-engineering - It is possible that production data volume is huge and given dataset is a sample to iterate quickly and do analysis on a single machine. The model probably will need re-engineering on a scalable system like Spark, which means model’s performance might also change when it runs on huge volume of data.

- Re-training - model will require re-training on new data and its performance will need to be re-evaluated and reported to stakeholders

## Experiment Design
It was observed in exploratory data analysis that customers with an international plan have more than 40% churn. It was further strengthened by the our predictive model that international calls, charges and plans are among top important features. Thus, I am of the opinion that the telecom company should experiment with international plan customer segment to explore ways to reduce churn and improve customer retention.


**Experiment Objective**

To deduce if offering a more competitive/niche international plan over the existing one will help to reduce customer churn

**Experiment Workflow**

- Telecom company to propose new international plans. For this analysis, let's assume the company came up with 2 new plans - Plan A & Plan B
- Randomly select a sample of existing customers with international plans. Assuming the telecom company has a huge customer bases, let’s choose a conservative sample size of 30k customers
- Randomly divide the sample into 3 groups - Plan A, Plan B & Existing Plan. Existing plan customers act as a control group and other two act as test group
- Charge customers as per their treatment group for one billing cycle
- Measure churn percentage in each treatment group

**Risks**

- Few customers might show dissatisfaction to change their existing plan without their prior consent and may churn or make customer service calls. This can be somewhat mitigated by notifying the customers beforehand - the company could be legally obliged to do so
- If the experiment doesn't prove to show significant drop in churn, then switching customers in test group back to existing plan may annoy them leading to possible churn. In this case, the telecom company can consider to offer these customers an option to switch or not.
