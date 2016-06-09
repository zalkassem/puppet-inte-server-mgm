Puppet::Type.type(:mksuser).provide(:integrity) do
  desc ''

  commands :integrity => '/opt/integrity/client/bin/integrity'

  def self.instances

    instances = []

    cmd = [ command(:integrity),
      'mksdomainusers',
      '--hostname=localhost',
      '--port=7001',
      '--user=fsaadmin',
      '--password=200MKS9'
    ]

    raw = Puppet::Util::Execution.execute(cmd, :failonfail => true, :uid => 'mks', :custom_environment => { 'PATH' => '/opt/integrity/client/bin', 'MKS_IC_INSTANCE_DIR' => '/opt/integrity' })
    status = raw.exitstatus

    raw.each_line { |line|
      hash = {
        :name => line.chomp,
        :ensure => :present,
        :provider => self.name,
      }
      instances << new(hash) unless hash.empty?
    }

    instances
  end

  def self.prefetch(resources)
    mksusers = instances
    resources.keys.each do |name|
      if provider = mksusers.find{ |i| i.name ==name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_hash = {
      :name   => @resource[:name],
      :ensure => :present,
    }
  end

  def destroy
    cmd = [ command(:integrity),
      'deletemksdomainuser',
      '--hostname=localhost',
      '--port=7001',
      '--user=fsaadmin',
      '--password=200MKS9',
      '--yes',
      "#{@property_hash[:name]}"
    ]

    raw = Puppet::Util::Execution.execute(cmd, :failonfail => true, :uid => 'mks', :custom_environment => { 'PATH' => '/opt/integrity/client/bin', 'MKS_IC_INSTANCE_DIR' => '/opt/integrity' })
    status = raw.exitstatus
    @property_hash.clear
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  mk_resource_methods

  def flush
    unless @property_hash.empty?
      cmd = [ command(:integrity),
        'createmksdomainuser',
        '--hostname=localhost',
        '--port=7001',
        '--user=fsaadmin',
        '--password=200MKS9',
        "--loginID=#{@property_hash[:name]}",
        "--userPassword=betz4103",
        "--email=lennart.betz@netways.de",
        "--fullName=Lennart Betz"
      ]

      raw = Puppet::Util::Execution.execute(cmd, :failonfail => true, :uid => 'mks', :custom_environment => { 'PATH' => '/opt/integrity/client/bin', 'MKS_IC_INSTANCE_DIR' => '/opt/integrity' })
      status = raw.exitstatus
    end
  end

end
