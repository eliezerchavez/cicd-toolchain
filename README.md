# CI/CD Toolchain

## Overview 🔍

This toolchain is a combination of tools that aid in the delivery, development, and management of software applications throughout the systems development life cycle, as coordinated by an organisation that uses DevOps practices.

This tools fit into one or more activities, which supports specific DevOps initiatives: Plan, Create, Verify, Package, Release, Configure, Monitor, and Version Control.

## Tools 🧰

* [Jenkins](https://www.jenkins.io/doc/) <br />
  A self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.
* [SonarQube](https://docs.sonarqube.org/8.6/) <br />
  An open-source platform developed by SonarSource for continuous inspection of code quality to perform automatic reviews with static analysis of code to detect bugs, code smells, and security vulnerabilities on 20+ programming languages. SonarQube offers reports on duplicated code, coding standards, unit tests, code coverage, code complexity, comments, bugs, and security vulnerabilities.
* [Nexus Repository Manager OSS](https://help.sonatype.com/repomanager3)
  * A proxy for remote repositories which caches artifacts saving both bandwidth and time required to retrieve a software artifact from a remote repository, and;
  * a host for internal artifacts providing an organization with a deployment target for software artifacts. An automatic code review tool to detect bugs, vulnerabilities, and code smells in your code.

## Author 🖋️
* **Eliezer Efrain Chavez** -  [eliezerchavez](https://www.linkedin.com/in/eliezerchavez)

## Local Installation
### Pre-Requisites 📋

* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) <br />
  Ansible is an open-source software provisioning, configuration management, and application-deployment tool enabling infrastructure as code. It runs on many Unix-like systems, and can configure both Unix-like systems as well as Microsoft Windows.

* A user with sudo capabilities.
### Install ✔️

```bash
ansible-playbook install.yml
```
or
```bash
ansible-playbook install.yml -e *"\<variable_name>=\<variable_value>,..."*
```

You can override the value of the following variables in the playbook:

Variable Name | Default Value
---- | ---
```server``` | ```hostname```
```timezone``` | ```America/Lima```
```username``` | ```tools```

<br />After that you can access the tools via:

Tool | URL
---- | ---
Jenkins | http://\<server>/jenkins<br />e.g. http://localhost/jenkins
SonarQube | http://\<server>/sonarqube<br />e.g. http://toolchain.westus.cloudapp.azure.com/sonarqube
Nexus | http://\<server>/nexus<br />e.g. http://tools.local/nexus

<br />The **default credentials** for all the tools installed are: *admin/letmein*

### Uninstall ❌

```bash
ansible-playbook uninstall.yml
```

## Azure Installation
The following is *completely optional*!!!<br />
If your machine doesn't have enough resources to run this demo environment, you could use the provided [ARM Template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview) to provision the recommended environment.<br />

### Resource Creation ✔️

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  ```bash
  az group create -g CICDToolchain
  az group deployment create -g CICDToolchain -n CICDToolchain --template-file azure/toolchain.json \
    --parameters adminPublicKey="$(cat ~/.ssh/id_rsa.pub)" domainNameLabel=<label>
  ```
* [PowerShell](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-5.3.0)
  ```powershell
  New-AzResourceGroup -Name CICDToolchain
  New-AzResourceGroupDeployment -ResourceGroupName CICDToolchain `
    -TemplateFile azure/toolchain.json `
    -domainNameLabel <label> `
    -adminPublicKey <pubkey>
  ```

### Install ✔️

```bash
ansible-playbook -i <server_name>, -e *"\server=<server_name>,..."* -u <ssh_user> install.yml
```
### Uninstall ❌

```bash
ansible-playbook -i <server_name>, -e *"\server=<server_name>,..."* -u <ssh_user> uninstall.yml
```