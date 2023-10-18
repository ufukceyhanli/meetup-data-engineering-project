{% macro select_table(source_table, test_table) %}

    {% if var('unit_testing', false) == true %}
        {{ test_table }}
    {% else %}
        {{ source_table }}
    {% endif %}

{% endmacro %}
