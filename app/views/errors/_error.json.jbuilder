# frozen_string_literal: true

json.status error[:status].to_s
json.title error[:title].to_s
json.attribute error[:attribute].to_s if error[:attribute]
json.detail error[:detail].to_s
