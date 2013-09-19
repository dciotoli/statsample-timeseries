module Statsample
  module Regression
    module GLM

      class Poisson

        def self.mu(x, b, link=:log)
          if link.downcase.to_sym == :log
            (x * b).map { |y| Math.exp(y) }
          elsif link.downcase.to_sym == :sqrt
            (x * b).collect { |y| y**2 }
          end
        end

        def self.w(x, b)
          poisson_mu = mu(x,b)
          mu_flat = poisson_mu.column_vectors.map(&:to_a).flatten
          w_mat = Matrix.I(mu.size)
          mu_enum = mu_flat.to_enum
          return w_mat.map do |x|
            x.eql?(1) ? mu_enum.next : x
          end
        end

        def self.h(x, b, y)
          x_t = x.transpose
          mu_flat = mu(x,b).column_vectors.map(&:to_a).flatten
          column_data = y.zip(mu_flat).collect { |x| x.inject(:-) }
          x_t * Matrix.columns([column_data])
        end

        def self.j(x, b)
          w_matrix = w(x, b)
          jacobian_matrix = x.transpose * w_matrix * x
          jacobian_matrix.map { |x| -x }
        end

      end
    end
  end
end