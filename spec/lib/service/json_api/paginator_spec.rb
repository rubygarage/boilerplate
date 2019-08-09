# frozen_string_literal: true

RSpec.describe Service::JsonApi::Paginator do
  subject(:paginator) { described_class.call(resource_path: resource_path, pagy: pagy) }

  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:QUERY_PAGE_PARAMETER) }
  end

  describe '.call' do
    let(:resource_path) { 'resource_path' }
    let(:query_page_parameter) { Service::JsonApi::Paginator::QUERY_PAGE_PARAMETER }

    context 'when only 1 page available' do
      let(:pagy) { OpenStruct.new(page: 1, next: nil, prev: nil, pages: 1) }

      it 'returns object with page links' do
        expect(paginator).to eq(
          self: "#{resource_path}?#{query_page_parameter}=1",
          first: resource_path,
          next: nil,
          prev: nil,
          last: "#{resource_path}?#{query_page_parameter}=1"
        )
      end
    end

    context 'when has several pages' do
      let(:pagy) { OpenStruct.new(page: 2, next: 3, prev: 1, pages: 3) }

      it 'returns object with page links' do
        expect(paginator).to eq(
          self: "#{resource_path}?#{query_page_parameter}=2",
          first: resource_path,
          next: "#{resource_path}?#{query_page_parameter}=3",
          prev: "#{resource_path}?#{query_page_parameter}=1",
          last: "#{resource_path}?#{query_page_parameter}=3"
        )
      end
    end

    context 'when resource path not passed' do
      let(:pagy) { instance_double('Pagy', blank?: true) }

      it 'sets nill for blank pages' do
        %i[page next prev pages].each { |method| allow(pagy).to receive(method) }
        expect(paginator.compact).to eq(first: resource_path)
      end
    end
  end
end
