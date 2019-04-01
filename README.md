# Assignment

## SQL
- Please look at **customer_retention.sql** file. I have added my comments around few SQL clauses.
- I have also added a **customer_retention_jinja.sql** file. SQL here is exactly the same, but it uses JINJA to create as many retention months the user desires by updating num_months variable

## Modelling
I have added many markdown comments in the jupyter notebook **modelling.ipynb** that cover (a) to (d) parts of the question. Part (e) is covered below:

Potential issues to deploy model into productions:

- Data ingestion - a production model won’t read data from a csv and should ideally be read from a data warehouse. Appropriate changes will be required to handle this matter.

- Re-engineering - It is possible that production data volume is huge and given dataset is a sample to iterate quickly and do analysis on a single machine. The model probably will need re-engineering on a scalable system like Spark, which means model’s performance might also change when it runs on huge volume of data.

- Re-training - model will require re-training on new data and its performance will need to be re-evaluated and reported to stakeholders

## Experiment Design

It was observed in exploratory data analysis that customers with an international plan have more than 40% churn. It was further strengthened by the our predictive model that international calls, charges and plans are among top important features. Thus, I am of the opinion that the telecom company should experiment with international plan customer segment to explore ways to reduce churn and improve customer retention.

**Experiment Objective**

To deduce if offering a more competitive/niche international plan over the existing one will help to reduce customer churn. 

**Experiment Workflow**

Let’s assume the telecom provider came up with a new “improved international plan” and will conduct an A/B test to measure drop in churn percentage of international plan customers.

Test group - customers switched to new plan
Control group - customers on existing international plan

***Null hypothesis***

Test group churn percentage = Control group churn percentage

***Alternate hypothesis***

Test group churn percentage ≠ Control group churn percentage

***Determine sample size***

Using the correct sample size is important to detect difference between the two churn percentages.

Baseline churn percentage - 40% (churn percentage among existing international plan customers)

Let’s assume we want to observer a minimum detectable effect of 4%.

Applying 95% statistical significance on an online calculator, we get a sample size of 14,000 per group. Experimenting with 28k customers seems reasonable for a telecom provider as they have customer bases in millions.

**Implementation**

- Randomly select a sample of 28,000 existing customers with international plans
- Randomly divide sample into 2 groups - new plan (test) & existing plan (control)
- Charge customers as per their treatment group for one billing cycle
- Measure churn percentage in each treatment group

**Measure**

Measure churn percentages in both the groups. If we see a minimum drop in churn percentage of 4% then we reject the null hypothesis.

**Risks**

- Few customers might show dissatisfaction to change their existing plan without their prior consent and may churn or make customer service calls. This can be somewhat mitigated by notifying the customers beforehand - the company could be legally obliged to do so
- If the experiment doesn't prove to show significant drop in churn, then switching customers in test group back to existing plan may annoy them leading to possible churn. In this case, the telecom company can consider to offer these customers an option to switch or not.
