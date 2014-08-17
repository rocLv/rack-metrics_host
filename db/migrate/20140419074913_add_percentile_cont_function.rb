class AddPercentileContFunction < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute('
      CREATE OR REPLACE FUNCTION array_sort (ANYARRAY)
      RETURNS ANYARRAY LANGUAGE SQL
      AS $$
      SELECT ARRAY(
          SELECT $1[s.i] AS "foo"
          FROM
              generate_series(array_lower($1,1), array_upper($1,1)) AS s(i)
          ORDER BY foo
      );
      $$;
    ')

    ActiveRecord::Base.connection.execute('
      CREATE OR REPLACE FUNCTION percentile_cont(myarray double precision[], percentile real)
      RETURNS real AS
      $$

      DECLARE
        ary_cnt INTEGER;
        row_num real;
        crn real;
        frn real;
        calc_result real;
        new_array real[];
      BEGIN
        ary_cnt = array_length(myarray,1);
        row_num = 1 + ( percentile * ( ary_cnt - 1 ));
        new_array = array_sort(myarray);

        crn = ceiling(row_num);
        frn = floor(row_num);

        if crn = frn and frn = row_num then
          calc_result = new_array[row_num];
        else
          calc_result = (crn - row_num) * new_array[frn]
                  + (row_num - frn) * new_array[crn];
        end if;

        RETURN calc_result;
      END;
      $$
        LANGUAGE "plpgsql" IMMUTABLE;
    ')
    ActiveRecord::Base.connection.execute('
      CREATE OR REPLACE FUNCTION percentile_95th (double precision[])
      RETURNS real LANGUAGE SQL
      AS $$
      SELECT percentile_cont($1, 0.95);
      $$;
    ')
    ActiveRecord::Base.connection.execute("
      drop aggregate IF EXISTS percentile_95th(double precision);
      CREATE AGGREGATE percentile_95th (double precision)(
        sfunc = array_append,
        stype = double precision[],
        finalfunc=percentile_95th
      )
    ")
  end

  def down
    ActiveRecord::Base.connection.execute('drop function array_sort (ANYARRAY);')
    ActiveRecord::Base.connection.execute('drop function percentile_cont(myarray double precision[], percentile real);')
    ActiveRecord::Base.connection.execute('drop function percentile_95th(double precision);')
    ActiveRecord::Base.connection.execute('drop aggregate percentile_95th(double precision);')
  end
end
