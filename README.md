# Cours DevOpsSec - Apprendre Terraform

Cette repo est dédiée à mon apprentissage de l'IaC avec Terraform à travers [ce cours de DevOpsSec](https://devopssec.fr/category/apprendre-terraform), qui utilise AWS comme base pour l'infrastructure.
Je la mettrai à jour avec mes fichiers de configuration, mais aussi mes problèmes rencontrés et les adaptations faites par rapport aux tutoriels.

## Conclusions

Section future.

## Suivi des cours

### 1. Installation de Terraform

Rien à dire ici. Puisque je suis basé Arch, l'installation de Terraform est un simple `sudo pacman -S terraform`.

### 2. Première infra AWS depuis Terraform

À retenir:
- Terraform se charge de l'infrastructure, et mémorise les artefacts créés, avec les intégrations des fournisseurs comme AWS.
- Configuration dans `.tf`, variables dans `.tfvars`. 
- `terraform init` -> `terraform plan` -> `terraform apply`
- `user_data` ne fonctionne qu'en démarrage d'instance. Réinitialisation à faire manuellement si `user_data_replace_on_change` n'est pas activé.

Afin de faciliter la publication de mon avancement sur Git, je décide de complexifier un peu par rapport au tutoriel et sépare la configuration entre `.tf` et `.tfvars`, en utilisant `variables.tf` pour définir mes variables, et `main.tf` pour définir l'infrastructure.
Les secrets de configuration restent ainsi bien séparés dans un fichier `terraform.tfvars` que je peux ignorer de Git.

Quelques changements depuis la publication du cours, tout particulièrement sur l'utilisation gratuite d'AWS : le Free Tier est maintenant constitué d'un plus grand choix de machines mais est restreint par la quantité de crédits fournis.
Je passe donc le type d'instance à `t3.micro`, et décide d'utiliser une image Amazon Linux plutôt qu'Ubuntu.

J'ai sinon suivi les étapes de manière similaire, à l'exception d'avoir placé le script pour `user_data` dans un fichier séparé pour plus de clarté dans le code.
Pourtant, je ne parviens pas à accéder à la page web au port 80 de l'instance. Une vérification par SSH dans la console montre que le service `httpd` n'est pas installé, donc le script n'a pas tourné.

Après vérification dans la documentation, Amazon Linux utilise le format [Cloud-init](https://docs.cloud-init.io/en/latest/).
Je crée un fichier YAML selon la spécification et essaye à nouveau, sans succès complet : `httpd` est installé mais non démarré, donc seules les directives de package ont été lancées.
Des vérification dans les logs cloud-init (`/var/log/cloud-init-output.log`) me font enfin comprendre qu'il faut relancer l'instance entièrement pour que le script soit exécuté. Après cela, la page web devient accessible.
