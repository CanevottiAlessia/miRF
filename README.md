# miR-RF REPOSITORY

The miR-RF repository provides a machine learning-based framework for evaluating and classifying pre-microRNAs (pre-miRNAs) using the Random Forest algorithm. This tool is designed to help in analysing the viability of pre-miRNAs and assess the potential impact of single nucleotide variations (SNVs) on their structural stability. 

The repository includes two distinct applications: 
miR-RF → A predictive tool that determines whether a given pre-miRNA is viable or not, based on its structural features;
miR-RF_classes → A classification tool that assigns pre-miRNAs into four classes (Resilient, Dispensable, Spurious, Inducible) by evaluating how SNVs affect their structure.

Overview of the two applications:

| Application       | Purpose | Input | Output |
|------------------|---------|-------|--------|
| **miR-RF** | Predicts pre-miRNA viability using a machine learning model | RNAfold output file | "2" (Viable) or "1" (Non-viable) |
| **miR-RF_classes** | Classifies pre-miRNAs into four functional classes based on SNV impact | RNAfold + FASTA file + output from miR-RF | **R (Resilient), D (Dispensable), S (Spurious), I (Inducible)** |

---

># **miR-RF APPLICATION**

The miR-RF application is a predictive workflow for evaluating pre-miRNAs based on the machine learning algorithm Random Forest. It consists of Python and R scripts designed to process RNAfold Vienna outputs, extract characteristic features, perform machine learning analysis and generate predictions.

### Overview

The miR-RF application is comprised of Python and R scripts:
- **Python Scripts (Pre-processing):**
  - Extracts features from pre-miRNAs present in RNAfold output files;
  - Converts extracted features into a numerical format and produces an intermediate file for R processing;
  - Input: RNAfold output file;
  - Output: Intermediate file with extracted features.
- **R Scripts (Machine Learning):**
  - Performs machine learning analysis on the intermediate file generated by the Python script;
  - Generates a text file containing predictions for each pre-miRNA in the input;
  - Input: Intermediate file generated by the Python script;
  - Output: Text file with predictions (2 for YES, 1 for NO) for each pre-miRNA.

### Input Requirements

- The application accepts RNAfold files as inputs, structured in the following format:
1. Header line starting with ">";
2. Sequence, reported with A, G, C and U letters;
3. MFE structure, reported within round brackets;
4. Ensemble structure, with energy reported in square brackets;
5. Centroid structure, with its energy and the minimal base-pair distance to all the structures in the thermodynamic ensemble, reported in curly brackets;
6. Frequency of MFE structure in ensemble and ensemble diversity.

In order to obtain the appropriate input for miR-RF, you can install RNAfold Vienna package on your machine, by running:

```bash
conda install -c bioconda viennarna
conda install -c "bioconda/label/cf201901" viennarna
RNAfold -p -d2 --noLP --noDP --noPS --jobs=<n of threads> <input_file> > <output_RNAfold_file>
```

This command creates the <output_RNAfold_file> file, which is the input for miR-RF. The <input_file> is a FASTA or a multi-FASTA file. 

**Important notes**:
- The header/s in the FASTA file CANNOT contain values separated by "\t". Therefore, you can convert the header/s into a different format, by using the provided `format_headers.py` Python script as:

```bash
python3 format_headers.py <input_file> <output_file>
```
It replaces single spaces ' ' and tabs '\t' into '_'. Any other separator will remain the same. 

- The header/s and the respective sequence/s must be different for each entry. Two or more miRNAs, even if they have different names, CANNOT have the same sequence. In order to process this type of hairpins, you can execute the provided `group_same_sequences.py` Python script as:

```bash
python3 group_same_sequences.py <input_file> <output_file>
```
The script reports only one sequence and the corresponding multiple headers separated by "|". 


### miR-RF input example

Sample input file structure:

```plaintext
>hsa-let-7a-1
UGGGAUGAGGUAGUAGGUUGUAUAGUUUUAGGGUCACACCCACCACUGGGAGAUAACUAUACAAUCUACUGUCUUUCCUA
(((((.(((((((((((((((((((((.....(((...((((....)))).))))))))))))))))))))))))))))) (-34.20)
{((((.(((((((((((((((((((((.....(((...((({....}))).))))))))))))))))))))))))))))} [-35.18]
(((((.(((((((((((((((((((((.....(((...((((....)))).))))))))))))))))))))))))))))) {-34.20 d=3.42}
 frequency of mfe structure in ensemble 0.203686; ensemble diversity 5.63
...
```

### miR-RF output example

The output file contains each pre-miRNA name and the corresponding prediction:

```plaintext
"miRNA name"       "prediction"
">hsa-let-7a-1"       "2"
```

### Installation

We recommend creating a new directory to neatly store all the requirements for miR-RF. This facilitates an organized environment for running the application efficiently. 

1. Conda Installation in Command Line:
   - Follow the instructions https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html to install and activate Conda on your system.

3. Activating the Conda environment:
   - Once Conda is installed and activated, clone the URL provided, this imports in you machine all the necessary files for miR-RF to work:
   
   ```bash
   git clone <repository_URL>
   ```
   
  The files used by miR-RF are the following:
   - `miR_configuration_file.yml`: conda environment configuration file;
   - `PY_miR_features_extraction.py`: Python script for feature extraction from pre-miRNAs;
   - `make_miR_pred.R`: R script for making predictions using machine learning;
   - `trained_model_new.RDS`: Includes the pre-trained model data necessary for predictions;
   - `miR_application.py`: Executor program coordinating the feature extraction and prediction processes.

  Additional files present in miR-RF repository:
   - `make_miR_Training.R`: R script for training the model;
   - `make_miR_testing.R`: R script for testing the model;
   - `example_input_sequences.txt`: Example of miR-RF input;
   - `format_headers.py`: Python script for formatting the input;
   - `miR-RF_classes`: Directory of the second application. 
  
4. Use `miR_configuration_file.yml` file to configure an environment suitable for running miR-RF. It contains a specific set of channel configurations and package installations essential for the execution of the application.
     
   ```bash
   conda env create -f miR_configuration_file.yml
   ```
   Note: Creating the environment may take some time because Conda downloads and installs all the necessary packages and dependencies.

   - Activate the env by:
   
   ```bash
   conda activate miR_RF
   ```

5. Running miR-RF application:

   ```bash
   python3 miR_application.py <input_file> <output_file>
   ```
   Replace input_file with the name of the file containing <output_RNAfold_file>. Similarly, replace output_file with the desired name for the prediction results file.

   Example Usage:

   ```bash
   python3 miR_application.py example_input_sequences.txt predictions_output.txt
   ```
   `example_input_sequences.txt`: Example input file containing pre-miRNA data (the file is provided);
   
   `predictions_output.txt`: Output file to store the prediction results.

   Ensure that the input file follows the specified format (see Input requirements). Upon executing this command, the `miR_application.py` program will process the input data, execute feature extraction, and 
   generate predictions using the trained model.

---

># **miR-RF_classes APPLICATION**

The **miR-RF_classes** is the second application in the miR-RF repository. It provides a workflow, based on Python and R scripts, that classifies each pre-miRNA, previously evaluated with the miR-RF application, into one of four distinct classes:
- **R** (Resilient);
- **D** (Dispensable);
- **S** (Spurious);
- **I** (Inducible). 

### Overview

A comprehensive in silico analysis can be undertaken to evaluate the potential impact of SNV on the structural stability/viability of precursor miRNAs. All the possible SNVs with respect to the reference sequence can be inserted, individually at every position in one or more pre-miRNAs. The newly generated sequence/s is/are processed according to the miR-RF application workflow, and comparison between the class assigned to the in silico mutated sequences and the reference sequence are used as a proxy to assess the potential impact. 
Four different outcomes are possible:  
- **Neutral SNV**: both the reference miRNA sequence and the mutated sequence are evaluated as **2** --> SNP is considered neutral and miRNAs with this feature are classified as **R**;
- **Deactivating SNV**: reference miRNA sequence is evaluated as **2**; mutated miRNA sequence is evaluated as **1** --> SNP is considered damaging and miRNAs with at least one deactivating SNP are classified as **D**;
- **No impact SNV**: both the reference sequence and the mutated sequences are evaluated as **1** --> SNP has no impact and miRNAs with this feature were classified as **S**;
- **Activating SNV**: reference miRNA sequence evaluated as **1**; mutated sequence as **2** --> SNP is considered activating and miRNAs with at least one are classified as **I**.

### Requirements

All the necessary files are present in the miR-RF_classes directory, that you should have already downloaded when cloned the URL provided. The files included are the following: 

 - `miR_classes.py`: Python script that executes the workflow;
 - `format_header.py`: Python script for formatting the header;
 - `get_fasta_for_insertion.py`: Python script for hairpin/s processing;
 - `SNP_insertion.py`: Python script for inserting SNPs in reference sequence/s;
 - `2_miR_application.py`: Executor program coordinating the feature extraction (`PY_miR_features_extraction.py`) and prediction processes (`make_miR_pred_classes2.R`), based on `trained_model_new.RDS`;
 - `merge_table.py`: Python script for comparing the predictions made on reference sequence/s and the prediction/s made on sequence/s with all the potential SNP inserted;
 - `get_lens.py`: Python script for extracting hairpin/s length/s;
 - `make_fisher_test.py`: Python script for computing the fisher test for adjusting the class;
 - `make_first_classes.py`: Python script for giving a temporary class to each pre-miRNA;
 - `make_final_classes.py`: Python script for giving the definitive class, corrected with the Fisher test, to each pre-miRNA.


- The miR-RF_classes application works in the same environment as miR-RF application, make sure it is activated. 
- All the above mentioned requirements valid for miR-RF application has to be respected also for miR-RF_classes tool.


### Running miR-RF_classes

The miR-RF_classes application has 4 requirements for running: 

  1. RNAfold file: this has to be the same file you gave as input to miR-RF application:

  ```plaintext
  >hsa-let-7a-1
  UGGGAUGAGGUAGUAGGUUGUAUAGUUUUAGGGUCACACCCACCACUGGGAGAUAACUAUACAAUCUACUGUCUUUCCUA
  (((((.(((((((((((((((((((((.....(((...((((....)))).))))))))))))))))))))))))))))) (-34.20)
  {((((.(((((((((((((((((((((.....(((...((({....}))).))))))))))))))))))))))))))))} [-35.18]
  (((((.(((((((((((((((((((((.....(((...((((....)))).))))))))))))))))))))))))))))) {-34.20 d=3.42}
   frequency of mfe structure in ensemble 0.203686; ensemble diversity 5.63
  ```
  2. FASTA file: this has to be the FASTA from which the RNAfold file is obtained:

  ```plaintext
  >hsa-let-7a-1
  UGGGAUGAGGUAGUAGGUUGUAUAGUUUUAGGGUCACACCCACCACUGGGAGAUAACUAUACAAUCUACUGUCUUUCCUA
  ```

  3. Prediction file: this is the output of miR-RF application:

  ```plaintext
  "miRNA name"       "prediction"
  ">hsa-let-7a-1"       "2"
  ```
  
  4. Output file: this is the output of miR-RF_classes application -- you have to choose the name of the file.

  ```plaintext
  "miRNA name"       "class"
  ">hsa-let-7a-1"       "R"
  ```

In command line: 

```bash
python3 miR_classes.py <input_file 1> <input_file 2> <input_file 3> <output_file>
```

Example Usage:

```bash
python3 miR_classes.py example_input_sequences.txt example_input_sequences.fa predictions_output.txt classes_output.txt
```
