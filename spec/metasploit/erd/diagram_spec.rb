RSpec.describe Metasploit::ERD::Diagram do
  subject(:diagram) do
    described_class.new(*arguments)
  end

  let(:arguments) do
    [
      domain
    ]
  end

  let(:domain) do
    RailsERD::Domain.new
  end

  it { is_expected.to be_a RailsERD::Diagram::Graphviz }

  context 'CONSTANTS' do
    context 'ATTRIBUTES' do
      subject(:attributes) do
        described_class::ATTRIBUTES
      end

      it { is_expected.to include :content }
      it { is_expected.to include :foreign_keys }
      it { is_expected.to include :primary_keys }
      it { is_expected.to include :timestamps }
    end

    context 'DEFAULT_OPTIONS' do
      subject(:default_options) do
        described_class::DEFAULT_OPTIONS
      end

      context '[:attributes]' do
        subject(:attributes) do
          default_options[:attributes]
        end

        it 'should be ATTRIBUTES' do
          expect(attributes).to eq(described_class::ATTRIBUTES)
        end
      end

      context '[:filetype]' do
        subject(:filetype) do
          default_options[:filetype]
        end

        it 'should be FILETYPE' do
          expect(filetype).to eq(described_class::FILETYPE)
        end
      end

      context '[:indirect]' do
        subject(:indirect) do
          default_options[:indirect]
        end

        it 'should be INDIRECT' do
          expect(indirect).to eq(described_class::INDIRECT)
        end
      end

      context '[:inheritance]' do
        subject(:inheritance) do
          default_options[:inheritance]
        end

        it 'should be INHERITANCE' do
          expect(inheritance).to eq(described_class::INHERITANCE)
        end
      end

      context '[:notation]' do
        subject(:notation) do
          default_options[:notation]
        end

        it 'should be NOTATION' do
          expect(notation).to eq(described_class::NOTATION)
        end
      end

      context '[:polymorphism]' do
        subject(:polymorphism) do
          default_options[:polymorphism]
        end

        it 'should be POLYMORPHISM' do
          expect(polymorphism).to eq(described_class::POLYMORPHISM)
        end
      end
    end

    context 'FILETYPE' do
      subject(:filetype) do
        described_class::FILETYPE
      end

      it { is_expected.to eq(:png) }
    end

    context 'INDIRECT' do
      subject(:indirect) do
        described_class::INDIRECT
      end

      it { is_expected.to eq(false) }
    end

    context 'INHERITANCE' do
      subject(:inheritance)  do
        described_class::INHERITANCE
      end

      it { is_expected.to eq(true) }
    end

    context 'NOTATION' do
      subject(:notation) do
        described_class::NOTATION
      end

      it { is_expected.to eq(:crowsfoot) }
    end

    context 'POLYMORPHISM' do
      subject(:polymorphism) do
        described_class::POLYMORPHISM
      end

      it { is_expected.to eq(true) }
    end
  end

  context 'callbacks' do
    subject(:callbacks) do
      described_class.send(:callbacks)
    end

    context '[:each_entity]' do
      subject(:each_entity) do
        callbacks[:each_entity]
      end

      it { is_expected.to_not be_nil }

      it 'uses RailsERD::Diagram::Graphviz.callbacks[:each_entity]' do
        expect(each_entity).to eq(RailsERD::Diagram::Graphviz.send(:callbacks)[:each_entity])
      end
    end

    context '[:each_relationship]' do
      subject(:each_relationship) do
        callbacks[:each_relationship]
      end

      it { is_expected.to_not be_nil }

      it 'uses RailsERD::Diagram::Graphviz.callbacks[:each_relationship]' do
        expect(each_relationship).to eq(RailsERD::Diagram::Graphviz.send(:callbacks)[:each_relationship])
      end
    end

    context '[:each_specialization]' do
      subject(:each_specialization) do
        callbacks[:each_specialization]
      end

      it { is_expected.to_not be_nil }

      it 'uses RailsERD::Diagram::Graphviz.callbacks[:each_specialization]' do
        expect(each_specialization).to eq(RailsERD::Diagram::Graphviz.send(:callbacks)[:each_specialization])
      end
    end

    context '[:save]' do
      subject(:save) do
        callbacks[:save]
      end

      it { is_expected.to_not be_nil }

      it 'extends RailsERD::Diagram::Graphviz.callbacks[:save]' do
        expect(save).not_to eq(RailsERD::Diagram::Graphviz.send(:callbacks)[:save])
      end
    end

    context '[:setup]' do
      subject(:setup) do
        callbacks[:setup]
      end

      it { is_expected.to_not be_nil }

      it 'uses RailsERD::Diagram::Graphviz.callbacks[:setup]' do
        expect(setup).to eq(RailsERD::Diagram::Graphviz.send(:callbacks)[:setup])
      end
    end
  end

  context '#initialize' do
    context 'with domain' do
      it 'uses first argument as domain' do
        expect(diagram.domain).to eq(arguments.first)
      end

      context 'with options' do
        let(:arguments) do
          super() + [options]
        end

        let(:options) do
          {
            key: :value
          }
        end

        it 'merges options with DEFAULT_OPTIONS' do
          expect(described_class::DEFAULT_OPTIONS).to receive(:merge).with(options).and_call_original

          diagram
        end
      end

      context 'without options' do
        it 'uses DEFAULT_OPTIONS as #options' do
          described_class::DEFAULT_OPTIONS.each do |key, value|
            expect(diagram.options[key]).to eq(value)
          end
        end
      end
    end
  end
end
