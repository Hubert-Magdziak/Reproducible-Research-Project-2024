Link to data: https://www.kaggle.com/datasets/sunnykakar/spotify-charts-all-audio-data/data

Sundeep Kakar. (2024). Spotify Charts (All Audio Data) [Data set]. Kaggle. https://doi.org/10.34740/KAGGLE/DSV/8129495

The data in this folder comes from Kaggle. Due to big size of original data (almost 28GB), the data was preprocessed and aggregated locally. Only the file containing aggregated data is uploaded, as also the size of preprocessed mid-file is too big to be kept in the repository. The orginal file is available to download under the links.

For the reproducibility matters, 'charts-prep.ipynb' Python Notebook with the code used to process the original data is uploaded. In the file there are functions that help with preprocessing, notably function 'read_big_file' which is called in a loop that allows to process data chunks.

The user shall make sure that while calling the functions proper paths to files are provided. Preprocessed (selection based on region, dates and variable names) is saved as 'processed_data.csv' and further used to create the final file: 'merged_data.csv'.
