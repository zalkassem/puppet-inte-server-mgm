Puppet::Type.type(:mksgroup).provide(:integrity) do
  desc ''

  commands :integrity => '/opt/integrity/client/bin/integrity'

  raw = Puppet::Util::Execution.execute(
    [ command(:integrity), 'connect',
      '--hostname=localhost',
      '--port=7001',
      '--user=fsaadmin',
      '--password=200MKS9'
    ],
    :failonfail => true,
    :uid => 'mks',
    :custom_environment => {
      'PATH' => '/opt/integrity/client/bin',
      'MKS_IC_INSTANCE_DIR' => '/opt/integrity'
    })

  def self.instances

    instances = []

    raw = Puppet::Util::Execution.execute(
      [ command(:integrity), 'mksdomaingroups' ],
      :failonfail => false,
      :uid => 'mks',
      :custom_environment => {
        'PATH' => '/opt/integrity/client/bin',
       'MKS_IC_INSTANCE_DIR' => '/opt/integrity'
      })
    return false unless raw.exitstatus

    raw.each_line { |line|
      group = line.chomp
      attributes = Puppet::Util::Execution.execute(
        [ command(:integrity), 'viewmksdomaingroup', "#{group}" ],
        :failonfail => true,
        :uid => 'mks',
        :custom_environment => {
          'PATH' => '/opt/integrity/client/bin',
          'MKS_IC_INSTANCE_DIR' => '/opt/integrity'
        })
      return false unless attributes.exitstatus

      members = []; desc = ''
      attributes.each_line { |attr|
        #desc = attr.gsub(/^Description:\n(.*)/, '\1').chomp if /^Description/ =~ attr
        members << attr.gsub(/^\s+(\w+).*$/, '\1').chomp if /^\s/ =~ attr
      }

      hash = {
        :name => group,
        :ensure => :present,
        :provider => self.name,
        :members => members,
        #:desc => desc,
      }
      instances << new(hash) unless hash.empty?
    }

    instances
  end

  def self.prefetch(resources)
    mksgroups = instances
    resources.keys.each do |name|
      if provider = mksgroups.find{ |i| i.name ==name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_hash = {
      :name    => @resource[:name],
      :ensure  => :present,
      #:desc    => @resource[:desc],
      :members => @resource[:members],
    }
  end

  def destroy
    @property_hash[:ensure] = :absent
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  mk_resource_methods

  def flush
    unless @property_hash.empty?
      cmd = [ command(:integrity), 'deletemksdomaingroup', '--yes', "#{@property_hash[:name]}" ]
      raw = Puppet::Util::Execution.execute(
        cmd,
        :failonfail => false,
        :uid => 'mks',
        :custom_environment => {
          'PATH' => '/opt/integrity/client/bin',
          'MKS_IC_INSTANCE_DIR' => '/opt/integrity'
        })

      if @property_hash[:ensure] != :absent
        cmd = [ command(:integrity), 'createmksdomaingroup', "--description=", "--name=#{@property_hash[:name]}" ]
        #cmd << "--description=#{@property_hash[:desc]}" if @property_hash[:desc]
        cmd << "--members=#{@property_hash[:members].collect {|i| 'u='+i}.join(',')}" unless @property_hash[:members].nil?
        raw = Puppet::Util::Execution.execute(
          cmd,
          :failonfail => true,
          :uid => 'mks',
          :custom_environment => {
            'PATH' => '/opt/integrity/client/bin',
            'MKS_IC_INSTANCE_DIR' => '/opt/integrity'
          })
      else
        @property_hash.clear
      end
    end
  end

end
