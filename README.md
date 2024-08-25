# genomics-invoicing
This is a project intended to automate the generation of genomic invoices to customers.
## For future developers
### Windows users
#### 1. Setting up Windows Subsystem for Linux (WSL)
There are plenty of tutorials online, won't go into details here. Remember your WSL **username** and **password**, you will need it later.
#### 2. Install R
The author of this entry uses **Debian distribution** of WSL, the installation process may be different depending on your WSL distro. See more [here](https://cloud.r-project.org/index.html)

Run the following command in your console of WSL to install R:
```bash
sudo apt update
sudo apt install r-base r-base-dev
```
Check installation with:
```bash
R --version
```
#### 3. Install R studio server
Now install the latest R studio desktop. Go to the [official R-studio site](https://posit.co/download/rstudio-server/), select your distro and version correctly, and follow step 3. Code is not shown here because the download link may change upon updates. 
#### 4. Launch dev space
Run this command in your bash shell
```bash
sudo rstudio-server start
```
if you see some text starting with "TTY detected.", you are good to go. 
Now open your browser and type in:
```bash
http://localhost:8787
```
you should see a window asking for a user name and password. Use your WSL username and password. Then you can see your development environment in your browser successfully deployed.
### MAC users
to be filled


