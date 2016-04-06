include_recipe 'apt'

# Need mailutils for mail command
apt_package 'mailutils'

# Need libxml2-utils for xmllint
apt_package 'libxml2-utils'

# pygmentize for some nice xml coloring
apt_package 'python-pygments'
