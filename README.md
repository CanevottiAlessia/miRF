# miR-RF
  The "miR-RF" repository hosts a machine learning-based application designed for pre-microRNAs annotation and classification. 

---

# REPOSITORY DESCRIPTION

This repository hosts 2 distinct applications: 
1. miR-RF --> predictive tool using the Random Forest machine learning algorithm to evaluate pre-miRNAs viability;
2. miR-RF_classes --> tool classifing pre-miRNAs into 4 classes: R, D, S and I.

# miR-RF description

The miR-RF application is a predictive tool for evaluating pre-miRNAs based on the machine learning algorithm Random Forest. It consists of Python and R scripts designed to process RNAfold Vienna outputs, extract characteristic features, perform machine learning analysis and generate predictions.

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

The application accepts RNAfold output files as inputs, structured in the following format:
1. Header line starting with ">";
2. Sequence, reported with A, G, C and U letters;
3. MFE structure, reported within round brackets;
4. Ensemble structure, with energy reported in square brackets;
5. Centroid structure, with its energy and the minimal base-pair distance to all the structures in the thermodynamic ensemble, reported in curly brackets;
6. Frequency of MFE structure in ensemble and ensemble diversity.
   
- Multi-FASTA format is also supported.

In order to obtain the appropriate input for miR-RF, you can install RNAfold Vienna package on your machine, by running:

```bash
conda install -c bioconda viennarna
conda install -c "bioconda/label/cf201901" viennarna
RNAfold -p -d2 --noLP --noDP --noPS --jobs=<n of threads> <input_file> > <output_RNAfold_file>
```

This command creates the <output_RNAfold_file> file, which is the input for miR-RF. 

- Important note: since the header cannot contain values separated by "\t", the application converts any "\t" present in the header into a single space " ". 

  For example, from this input:
  
  ```plaintext
  >hsa-let-7a-1  first_example  1
  ```
  to: 
  
  ```plaintext
  >hsa-let-7a-1 first example 1
  ```

  Note: consider that the code only processes and replaces headers presenting the following symbol: "\t". Any other formats will remain in the final output as written in input.  
  
  
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
   - Once Conda is installed and activated, clone the URL provided, this imports in you machine all the files becessary for miR-RF to work:
   
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
  
4. Use `miR_configuration_file.yml` file to configurate an environment suitable for running miR-RF. It contains a specific set of channel configurations and package installations essential for the execution of the application.
     
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
