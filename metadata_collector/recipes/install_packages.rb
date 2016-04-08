include_recipe 'apt'

# Need mailutils for mail command
apt_package 'mailutils'

# Need libxml2-utils for xmllint
apt_package 'libxml2-utils'

# pygmentize for some nice xml coloring
apt_package 'python-pygments'

# Need pip for bzsales_reports
apt_package 'python-pip'

apt_package 'python-virtualenv'

# Some of the pip modules have C build steps that
# seem to link to python libraries
apt_package 'python-dev'
