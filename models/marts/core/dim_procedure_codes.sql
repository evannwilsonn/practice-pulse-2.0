select cdt_code, description as procedure_description, category as procedure_category
from {{ ref('procedure_codes') }}
