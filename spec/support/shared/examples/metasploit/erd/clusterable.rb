RSpec.shared_examples_for 'Metasploit::ERD::Clusterable' do
  include_context 'ActiveRecord::Base connection'

  #
  # Methods
  #

  def migrate
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Migration.create_table :dummy_factories do |t|
      t.timestamps null: false
    end

    ActiveRecord::Migration.create_table :dummy_widgets do |t|
      t.references :factory

      t.timestamps null: false
    end
  end

  #
  # lets
  #

  let(:dummy_module) do
    Module.new do
      def self.table_name_prefix
        'dummy_'
      end
    end
  end

  let(:dummy_factory) do
    Class.new(ActiveRecord::Base) do
      has_many :widgets,
               class_name: 'Dummy::Widget',
               inverse_of: :factory
    end
  end

  let(:dummy_widget) do
    Class.new(ActiveRecord::Base) do
      belongs_to :factory,
                 class_name: 'Dummy::Factory',
                 inverse_of: :widgets
    end
  end

  #
  # Callbacks
  #

  before(:each) do
    migrate

    stub_const('Dummy', dummy_module)
    stub_const('Dummy::Factory', dummy_factory)
    stub_const('Dummy::Widget', dummy_widget)
  end

  context '#diagram' do
    subject(:diagram) do
      entity.diagram(*arguments)
    end

    let(:arguments) do
      []
    end

    it { is_expected.to be_a Metasploit::ERD::Diagram }

    context 'Metasploit::ERD::Diagram#create' do
      subject(:create) do
        diagram.create
      end

      #
      # lets
      #

      let(:arguments) do
        [
          {
            directory: directory
          }
        ]
      end

      let(:directory) do
        spec_pathname.join('tmp')
      end

      let(:spec_pathname) do
        Pathname.new(__FILE__).parent.parent.parent.parent.parent.parent
      end

      #
      # Callbacks
      #

      before(:each) do
        directory.rmtree if directory.exist?
      end

      after(:each) do
        directory.rmtree
      end

      context 'directory' do
        context 'with existing' do
          before(:each) do
            directory.mkpath
          end

          it 'returns path where diagram was written' do
            expect(create).to be_a String
          end
        end

        context 'without existing' do
          it 'creates directory' do
            expect { create }.to change(directory, :directory?).to(true)
          end

          it 'returns path where diagram was written' do
            expect(create).to be_a String
          end
        end
      end
    end

    context 'Metasploit::ERD::Diagram#domain' do
      subject(:domain) do
        diagram.domain
      end

      it 'is #domain' do
        entity_domain = entity.domain
        allow(entity).to receive(:domain).and_return(entity_domain)

        expect(domain).to eq(entity_domain)
      end
    end

    context 'Metasploit::ERD::Diagram#options' do
      subject(:options) do
        diagram.options
      end

      context 'with :basename' do
        let(:arguments) do
          [
            argument_options
          ]
        end

        let(:argument_options) do
          {
            basename: argument_basename
          }
        end

        context 'with nil' do
          let(:argument_basename) do
            nil
          end

          it 'is not retained' do
            expect(options).not_to have_key(:basename)
          end
        end

        context 'without nil' do
          let(:argument_basename) do
            'basename.extra.extension'
          end

          it 'is not retained' do
            expect(options).not_to have_key(:basename)
          end

          context '[:filename]' do
            subject(:filename) do
              options[:filename]
            end

            it 'ends with :basename' do
              expect(filename).to end_with(argument_basename)
            end
          end

          context '[:directory]' do
            let(:argument_options) do
              super().merge(
                directory: argument_directory
              )
            end

            context 'with nil' do
              let(:argument_directory) do
                nil
              end

              it 'is not retained' do
                expect(options).not_to have_key(:directory)
              end

              context '[:filename]' do
                subject(:filename) do
                  options[:filename]
                end

                it 'uses Dir.pwd for the directory' do
                  expect(File.dirname(filename)).to eq(Dir.pwd)
                end
              end
            end

            context 'without nil' do
              let(:argument_directory) do
                '/a/directory'
              end

              it 'is not retained' do
                expect(options).not_to have_key(:directory)
              end

              context '[:filename]' do
                subject(:filename) do
                  options[:filename]
                end

                it 'uses :directory for the directory' do
                  expect(File.dirname(filename)).to eq(argument_directory)
                end
              end
            end
          end
        end
      end

      context '[:directory]' do
        it 'is not retained' do
          expect(options).not_to have_key(:directory)
        end
      end

      context '[:title]' do
        subject(:title) do
          options[:title]
        end

        it { is_expected.to be_a String }
      end
    end
  end

  context '#domain' do
    subject(:domain) do
      entity.domain
    end

    it 'creates RailsERD::Domain from #cluster Metasploit::ERD::Cluster#class_set' do
      # ensures entity's class defined cluster
      cluster = entity.cluster
      class_set = cluster.class_set

      expect(entity).to receive(:cluster).and_return(cluster)
      expect(cluster).to receive(:class_set).and_return(class_set)
      expect(RailsERD::Domain).to receive(:new).with(class_set, hash_including(warn: false))

      domain
    end
  end
end
