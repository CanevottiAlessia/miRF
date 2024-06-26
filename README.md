# miR-RF
  The "miR-RF" repository hosts a machine learning-based application designed to classify/annotate pre-microRNAs. 

---

# miR-RF APPLICATION Description

The miR-RF application is a predictive tool for evaluating pre-miRNAs based on the machine learning algorithm Random Forest. It consists of Python and R scripts designed to process RNAfold Vienna outputs, extract characteristic features, perform machine learning analysis and generate predictions.

### Overview

The miR-RF application is comprised of Python and R scripts:
- **Python Script (Pre-processing):**
  - Extracts features from pre-miRNAs present in RNAfold output files.
  - Converts extracted features into a numerical format and produces an intermediate file for R processing.
  - Input: RNAfold output file.
  - Output: Intermediate file with extracted features.
- **R Script (Machine Learning):**
  - Performs machine learning analysis on the intermediate file generated by the Python script.
  - Generates a text file containing predictions for each pre-miRNA in the input.
  - Input: Intermediate file generated by the Python script.
  - Output: Text file with predictions (2 for YES, 1 for NO) for each pre-miRNA.

### Input Requirements

The application accepts RNAfold output files as input, structured in the following format:
- A file with a header line starting with ">" followed by five subsequent lines for each pre-miRNA. 
For every input string, made by the header line and its sequence, the output is composed by four lines corresponding to:
1. MFE structure, reported within round brackets;
2. Ensemble structure, with energy reported in square brackets;
3. Centroid structure, with its energy and the minimal base-pair distance to all the structures in the thermodynamic ensemble, reported in curly brackets.
4. Frequency of MFE structure in ensemble and ensemble diversity
   
- Multi-FASTA format is also supported.

In order to obtain the appropriate input for miR-RF, you can install RNAfold Vienna package on your machine. To install this package run one of the following:

```bash
conda install -c bioconda viennarna
conda install -c "bioconda/label/cf201901" viennarna
```

To run it:

```bash
RNAfold -p -d2 --noLP --noDP --noPS <input_file> > <output_RNAfold_file>
```

This command creates the <output_RNAfold_file> file, which is the input for miR-RF. 

- The miR-RF application accommodates a range of input file extensions. Whether it's a .txt, .out, or another format, the application is engineered to process pre-miRNA data effectively, irrespective of the file extension. 
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
  
  
### Input Example

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

### Output Example

The output file contains each pre-miRNA name and the corresponding prediction:

```plaintext
"miRNA name"       "prediction"
">hsa-let-7a-1"       "2"
```

### Installation

Before beginning with the installation, we recommend creating a new directory to neatly store all the requirements for miR-RF. This facilitates a more organized environment for running the application efficiently. 
To create a new directory, for example named "miR-RF_application", in your current location, use the following command in the terminal:

```bash
mkdir miR-RF_application
```
This command will create a new directory named "miR-RF_application" within the current location. Users can then put the necessary files here. 

1. Conda Installation in Command Line:
   - Follow the provided instructions in the 'CONDA installation' file to install Conda on your system in the directory just created.

2. Activating the Conda environment:
   - Once Conda is installed, use the provided `miR_configuration_file.yml` file to create an environment suitable for running miR-RF.
   Download the `miR_configuration_file.yml` file and copy it in the new directory, as follows:

   ```bash
   cp miR_configuration_file.yml ~/miR-RF_application
   ```
   - In the command line, activate conda with the following command:

   ```bash
   conda activate
   ``` 
   
   - Remain in the directory containing the `miR_configuration_file.yml` file and type the following command:

   ```bash
   conda env create -f miR_configuration_file.yml
   ```
   Note: Creating the environment may take some time because Conda downloads and installs all the necessary packages and dependencies.

   - After the project environment is created, activate it by:

   ```bash
   conda activate miR_RF
   ```
   This step ensures that the appropriate environment, complete with all the necessary channels and packages required to run the miR-RF application, is activated. The miR_configuration_file.yml contains a specific set of channel
   configurations and package installations essential for the execution of the application.


4. Setting up the directory:
   - Add in the same directory where it is present the `miR_configuration_file.yml` the provided following files:
      - `PY_miR_features_extraction.py`: Python script for feature extraction from pre-miRNAs;
      - `make_miR_pred.R`: R script for making predictions using machine learning;
      - `trained_model_new.RDS`: Includes the pre-trained model data necessary for predictions;
      - `miR_application.py`: Executor program coordinating the feature extraction and prediction processes;
 
   On command line, copy the repository URL in the right directory and write:

   ```bash
   git clone <repository_URL>
   ```
   
   Note: make sure that `miR_configuration_file.yml`, `trained_model_new.RDS`, `PY_miR_features_extraction.py`, `make_miR_pred.R` and `miR_application.py` are located in the same directory. 
    

5. Running the miR-RF application:
   - To run miR-RF, use the following command in the terminal:

   ```bash
   python3 miR_application.py <input_file> <output_file>
   ```

   Replace input_file with the name of the file containing pre-miRNA data in the required format. Similarly, replace output_file with the desired name for the prediction results file.

   Example Usage:

   ```bash
   python3 miR_application.py miRNA_sequences.txt predictions.txt
   ```
   miRNA_sequences.txt: Example input file containing pre-miRNA data.
   
   predictions_output.txt: Output file to store the prediction results.

   Ensure that the input file follows the specified format (see Input requirements). Upon executing this command, the `miR_application.py` program will process the input data, execute feature extraction, and generate predictions using the
   trained model.


7. Example input files:
   
   Use the provided files, called "miRNA_sequences.txt" and "miRNA_mouse_sequences.txt", if needed, in order to obtain and run an input example.


8. Visualising the output:

   In order to display the final output, you can type "less" or "more" in the command line, for example:

   ```bash
   less <output_file>
   ```
