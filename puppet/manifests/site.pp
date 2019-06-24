require stdlib
Package {allow_virtual => false}
unless $cluster {$cluster = hiera('cluster', 'undef')}
#
# Om de modules compatible te houden tussen RHEL5 en RHEL6, introduceren
# we hier de $input_chain_name variable. Overal waar firewall regels toegevoegd
# worden aan de input chain, dient deze variable gebruikt te worden. 
case $operatingsystemmajrelease {
  '5': {
    $input_chain_name  = 'RH-Firewall-1-INPUT'
    $output_chain_name = 'RH-Firewall-1-OUTPUT'
  }
  default: {
    $input_chain_name  = 'INPUT'
    $output_chain_name = 'OUTPUT'
  }
}

lookup('roles', {merge => unique}).include
