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
* **Eliezer Efrain Chavez** -  [eec](www.linkedin.com/in/eliezerchavez)

### Pre-Requisites 📋

* [Docker](https://www.docker.com/get-started) <br />
  A set of Platform as a Service (PaaS) products that use OS-level virtualization to deliver software in packages called containers. Containers are isolated from one another and bundle their own software, libraries and configuration files; they can communicate with each other through well-defined channels.
* [Docker Compose](https://docs.docker.com/compose/) <br />
  Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration.
### Install ✔️

Make sure you have sudo capabilities before run:
```
toolchain.sh init
```

After that you can access the tools via:
* Jenkins - http://localhost/jenkins
* SonarQube - http://localhost/sonarqube
* Nexus - http://localhost/nexus

### Uninstall ❌

Make sure you have sudo capabilities before run:
```
toolchain.sh clean
```
