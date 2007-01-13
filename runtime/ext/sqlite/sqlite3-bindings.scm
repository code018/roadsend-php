;; ***** BEGIN LICENSE BLOCK *****
;; Roadsend PHP Compiler Runtime Libraries
;; Copyright (C) 2007 Roadsend, Inc.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public License
;; as published by the Free Software Foundation; either version 2.1
;; of the License, or (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Lesser General Public License for more details.
;; 
;; You should have received a copy of the GNU Lesser General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
;; ***** END LICENSE BLOCK *****

(module sqlite3-c-bindings
   (extern
    (include "sqlite3.h")
    (include "sqlite-utils.h")
    
    ; stolen from standard lib, just used to set mode on sqlite db file
    (type pfl-mode_t uint "mode_t")  
    (macro pfl-chmod::int (::string ::pfl-mode_t) "chmod")
  
   (macro R_SQLITE_VERSION::string "SQLITE_VERSION")
   (macro R_SQLITE_VERSION_NUMBER::long "SQLITE_VERSION_NUMBER")
   (macro R_SQLITE_OK::long "SQLITE_OK")
   (macro R_SQLITE_ERROR::long "SQLITE_ERROR")
   (macro R_SQLITE_INTERNAL::long "SQLITE_INTERNAL")
   (macro R_SQLITE_PERM::long "SQLITE_PERM")
   (macro R_SQLITE_ABORT::long "SQLITE_ABORT")
   (macro R_SQLITE_BUSY::long "SQLITE_BUSY")
   (macro R_SQLITE_LOCKED::long "SQLITE_LOCKED")
   (macro R_SQLITE_NOMEM::long "SQLITE_NOMEM")
   (macro R_SQLITE_READONLY::long "SQLITE_READONLY")
   (macro R_SQLITE_INTERRUPT::long "SQLITE_INTERRUPT")
   (macro R_SQLITE_IOERR::long "SQLITE_IOERR")
   (macro R_SQLITE_CORRUPT::long "SQLITE_CORRUPT")
   (macro R_SQLITE_NOTFOUND::long "SQLITE_NOTFOUND")
   (macro R_SQLITE_FULL::long "SQLITE_FULL")
   (macro R_SQLITE_CANTOPEN::long "SQLITE_CANTOPEN")
   (macro R_SQLITE_PROTOCOL::long "SQLITE_PROTOCOL")
   (macro R_SQLITE_EMPTY::long "SQLITE_EMPTY")
   (macro R_SQLITE_SCHEMA::long "SQLITE_SCHEMA")
   (macro R_SQLITE_TOOBIG::long "SQLITE_TOOBIG")
   (macro R_SQLITE_CONSTRAINT::long "SQLITE_CONSTRAINT")
   (macro R_SQLITE_MISMATCH::long "SQLITE_MISMATCH")
   (macro R_SQLITE_MISUSE::long "SQLITE_MISUSE")
   (macro R_SQLITE_NOLFS::long "SQLITE_NOLFS")
   (macro R_SQLITE_AUTH::long "SQLITE_AUTH")
   (macro R_SQLITE_FORMAT::long "SQLITE_FORMAT")
   (macro R_SQLITE_RANGE::long "SQLITE_RANGE")
   (macro R_SQLITE_NOTADB::long "SQLITE_NOTADB")
   (macro R_SQLITE_ROW::long "SQLITE_ROW")
   (macro R_SQLITE_DONE::long "SQLITE_DONE")
   (macro R_SQLITE_COPY::long "SQLITE_COPY")
   (macro R_SQLITE_CREATE_INDEX::long "SQLITE_CREATE_INDEX")
   (macro R_SQLITE_CREATE_TABLE::long "SQLITE_CREATE_TABLE")
   (macro R_SQLITE_CREATE_TEMP_INDEX::long "SQLITE_CREATE_TEMP_INDEX")
   (macro R_SQLITE_CREATE_TEMP_TABLE::long "SQLITE_CREATE_TEMP_TABLE")
   (macro R_SQLITE_CREATE_TEMP_TRIGGER::long "SQLITE_CREATE_TEMP_TRIGGER")
   (macro R_SQLITE_CREATE_TEMP_VIEW::long "SQLITE_CREATE_TEMP_VIEW")
   (macro R_SQLITE_CREATE_TRIGGER::long "SQLITE_CREATE_TRIGGER")
   (macro R_SQLITE_CREATE_VIEW::long "SQLITE_CREATE_VIEW")
   (macro R_SQLITE_DELETE::long "SQLITE_DELETE")
   (macro R_SQLITE_DROP_INDEX::long "SQLITE_DROP_INDEX")
   (macro R_SQLITE_DROP_TABLE::long "SQLITE_DROP_TABLE")
   (macro R_SQLITE_DROP_TEMP_INDEX::long "SQLITE_DROP_TEMP_INDEX")
   (macro R_SQLITE_DROP_TEMP_TABLE::long "SQLITE_DROP_TEMP_TABLE")
   (macro R_SQLITE_DROP_TEMP_TRIGGER::long "SQLITE_DROP_TEMP_TRIGGER")
   (macro R_SQLITE_DROP_TEMP_VIEW::long "SQLITE_DROP_TEMP_VIEW")
   (macro R_SQLITE_DROP_TRIGGER::long "SQLITE_DROP_TRIGGER")
   (macro R_SQLITE_DROP_VIEW::long "SQLITE_DROP_VIEW")
   (macro R_SQLITE_INSERT::long "SQLITE_INSERT")
   (macro R_SQLITE_PRAGMA::long "SQLITE_PRAGMA")
   (macro R_SQLITE_READ::long "SQLITE_READ")
   (macro R_SQLITE_SELECT::long "SQLITE_SELECT")
   (macro R_SQLITE_TRANSACTION::long "SQLITE_TRANSACTION")
   (macro R_SQLITE_UPDATE::long "SQLITE_UPDATE")
   (macro R_SQLITE_ATTACH::long "SQLITE_ATTACH")
   (macro R_SQLITE_DETACH::long "SQLITE_DETACH")
   (macro R_SQLITE_ALTER_TABLE::long "SQLITE_ALTER_TABLE")
   (macro R_SQLITE_REINDEX::long "SQLITE_REINDEX")
   (macro R_SQLITE_DENY::long "SQLITE_DENY")
   (macro R_SQLITE_IGNORE::long "SQLITE_IGNORE")
   (macro R_SQLITE_INTEGER::long "SQLITE_INTEGER")
   (macro R_SQLITE_FLOAT::long "SQLITE_FLOAT")
   (macro R_SQLITE_BLOB::long "SQLITE_BLOB")
   (macro R_SQLITE_NULL::long "SQLITE_NULL")
   (macro R_SQLITE_TEXT::long "SQLITE_TEXT")
   (macro R_SQLITE3_TEXT::long "SQLITE3_TEXT")
   (macro R_SQLITE_STATIC::int "SQLITE_STATIC")
   (macro R_SQLITE_TRANSIENT::int "SQLITE_TRANSIENT")
   (macro R_SQLITE_UTF8::long "SQLITE_UTF8")
   (macro R_SQLITE_UTF16LE::long "SQLITE_UTF16LE")
   (macro R_SQLITE_UTF16BE::long "SQLITE_UTF16BE")
   (macro R_SQLITE_UTF16::long "SQLITE_UTF16")
   (macro R_SQLITE_ANY::long "SQLITE_ANY")

   ; encode.c
   (macro sqlite_encode_binary::int (uchar* int uchar*) "sqlite_encode_binary")
   (macro sqlite_decode_binary::int (uchar* uchar*) "sqlite_decode_binary")

   ; sqlite-utils.c
   (macro sqlite_custom_function::int (sqlite3* string string int) "sqlite_custom_function")
   (macro sqlite_custom_aggregate::int (sqlite3* string obj int) "sqlite_custom_aggregate")   
   
   (macro sqlite3_temp_directory::string "sqlite3_temp_directory")
   (macro sqlite3_libversion::string () "sqlite3_libversion")
   (macro sqlite3_libversion_number::int () "sqlite3_libversion_number")
   (macro sqlite3_close::int (sqlite3*) "sqlite3_close")
   ;(macro sqlite3_exec::int (sqlite3* string sqlite3_callback void* string*) "sqlite3_exec")
   (macro sqlite3_last_insert_rowid::sqlite_int64 (sqlite3*) "sqlite3_last_insert_rowid")
   (macro sqlite3_changes::int (sqlite3*) "sqlite3_changes")
   (macro sqlite3_total_changes::int (sqlite3*) "sqlite3_total_changes")
   (macro sqlite3_interrupt::void (sqlite3*) "sqlite3_interrupt")
   (macro sqlite3_complete::int (string) "sqlite3_complete")
;   (macro sqlite3_complete16::int (void*) "sqlite3_complete16")
;   (macro sqlite3_busy_handler::int (sqlite3* *void*,int->int void*) "sqlite3_busy_handler")
   (macro sqlite3_busy_timeout::int (sqlite3* int) "sqlite3_busy_timeout")
   (macro sqlite3_get_table::int (sqlite3* string string** int* int* string*) "sqlite3_get_table")
   (macro sqlite3_free_table::void (string*) "sqlite3_free_table")
   (macro sqlite3_mprintf::string (string . string) "sqlite3_mprintf")
;   (macro sqlite3_vmprintf::string (string va_list) "sqlite3_vmprintf")
   (macro sqlite3_free::void (string) "sqlite3_free")
   (macro sqlite3_snprintf::string (int string string . string) "sqlite3_snprintf")
;   (macro sqlite3_set_authorizer::int (sqlite3* *void*,int,string,string,string,string->int void*) "sqlite3_set_authorizer")
;   (macro sqlite3_trace::void* (sqlite3* *void*,string->void void*) "sqlite3_trace")
;   (macro sqlite3_progress_handler::void (sqlite3* int *void*->int void*) "sqlite3_progress_handler")
;   (macro sqlite3_commit_hook::void* (sqlite3* *void*->int void*) "sqlite3_commit_hook")

   (macro sqlite3_open::int (string sqlite3**) "sqlite3_open")
   
;   (macro sqlite3_open16::int (void* sqlite3**) "sqlite3_open16")
   (macro sqlite3_errcode::int (sqlite3*) "sqlite3_errcode")
   (macro sqlite3_errmsg::string (sqlite3*) "sqlite3_errmsg")
;   (macro sqlite3_errmsg16::void* (sqlite3*) "sqlite3_errmsg16")
   (macro sqlite3_prepare::int (sqlite3* string int sqlite3_stmt** string*) "sqlite3_prepare")
;   (macro sqlite3_prepare16::int (sqlite3* void* int sqlite3_stmt** void**) "sqlite3_prepare16")
;   (macro sqlite3_bind_blob::int (macro sqlite3_stmt* int void* int *void*->void) "sqlite3_bind_blob")
   (macro sqlite3_bind_double::int (sqlite3_stmt* int double) "sqlite3_bind_double")
   (macro sqlite3_bind_int::int (sqlite3_stmt* int int) "sqlite3_bind_int")
   (macro sqlite3_bind_int64::int (sqlite3_stmt* int sqlite_int64) "sqlite3_bind_int64")
   (macro sqlite3_bind_null::int (sqlite3_stmt* int) "sqlite3_bind_null")
;   (macro sqlite3_bind_text::int (sqlite3_stmt* int string int *void*->void) "sqlite3_bind_text")
;   (macro sqlite3_bind_text16::int (sqlite3_stmt* int void* int *void*->void) "sqlite3_bind_text16")
   (macro sqlite3_bind_value::int (sqlite3_stmt* int sqlite3_value*) "sqlite3_bind_value")
   (macro sqlite3_bind_parameter_count::int (sqlite3_stmt*) "sqlite3_bind_parameter_count")
   (macro sqlite3_bind_parameter_name::string (sqlite3_stmt* int) "sqlite3_bind_parameter_name")
   (macro sqlite3_bind_parameter_index::int (sqlite3_stmt* string) "sqlite3_bind_parameter_index")
   (macro sqlite3_clear_bindings::int (sqlite3_stmt*) "sqlite3_clear_bindings")
   (macro sqlite3_column_count::int (sqlite3_stmt*) "sqlite3_column_count")
   (macro sqlite3_column_name::string (sqlite3_stmt* int) "sqlite3_column_name")
   (macro sqlite3_column_name16::void* (sqlite3_stmt* int) "sqlite3_column_name16")
   (macro sqlite3_column_decltype::string (sqlite3_stmt* int) "sqlite3_column_decltype")
   (macro sqlite3_column_decltype16::void* (sqlite3_stmt* int) "sqlite3_column_decltype16")
   (macro sqlite3_step::int (sqlite3_stmt*) "sqlite3_step")
   (macro sqlite3_data_count::int (sqlite3_stmt*) "sqlite3_data_count")
   (macro sqlite3_column_blob::void* (sqlite3_stmt* int) "sqlite3_column_blob")
   (macro sqlite3_column_bytes::int (sqlite3_stmt* int) "sqlite3_column_bytes")
;   (macro sqlite3_column_bytes16::int (sqlite3_stmt* int) "sqlite3_column_bytes16")
   (macro sqlite3_column_double::double (sqlite3_stmt* int) "sqlite3_column_double")
   (macro sqlite3_column_int::int (sqlite3_stmt* int) "sqlite3_column_int")
;   (macro sqlite3_column_int64::sqlite_int64 (sqlite3_stmt* int) "sqlite3_column_int64")
   (macro sqlite3_column_text::uchar* (sqlite3_stmt* int) "sqlite3_column_text")
;   (macro sqlite3_column_text16::void* (sqlite3_stmt* int) "sqlite3_column_text16")
   (macro sqlite3_column_type::int (sqlite3_stmt* int) "sqlite3_column_type")
   (macro sqlite3_finalize::int (sqlite3_stmt*) "sqlite3_finalize")
   (macro sqlite3_reset::int (sqlite3_stmt*) "sqlite3_reset")

   (macro sqlite3_create_function::int (sqlite3* string int int void* void* void* void*) "sqlite3_create_function")
   
;   (macro sqlite3_create_function::int (sqlite3* string int int void* *sqlite3_context*,int,sqlite3_value**->void *sqlite3_context*,int,sqlite3_value**->void *sqlite3_context*->void) "sqlite3_create_function")
;   (sqlite3_create_function16::int (sqlite3* void* int int void* *sqlite3_context*,int,sqlite3_value**->void *sqlite3_context*,int,sqlite3_value**->void *sqlite3_context*->void) "sqlite3_create_function16")
   (macro sqlite3_aggregate_count::int (sqlite3_context*) "sqlite3_aggregate_count")
   (macro sqlite3_value_blob::void* (sqlite3_value*) "sqlite3_value_blob")
   (macro sqlite3_value_bytes::int (sqlite3_value*) "sqlite3_value_bytes")
;   (macro sqlite3_value_bytes16::int (sqlite3_value*) "sqlite3_value_bytes16")
   (macro sqlite3_value_double::double (sqlite3_value*) "sqlite3_value_double")
   (macro sqlite3_value_int::int (sqlite3_value*) "sqlite3_value_int")
;   (macro sqlite3_value_int64::sqlite_int64 (sqlite3_value*) "sqlite3_value_int64")
   (macro sqlite3_value_text::uchar* (sqlite3_value*) "sqlite3_value_text")
;   (macro sqlite3_value_text16::void* (sqlite3_value*) "sqlite3_value_text16")
;   (macro sqlite3_value_text16le::void* (sqlite3_value*) "sqlite3_value_text16le")
;   (macro sqlite3_value_text16be::void* (sqlite3_value*) "sqlite3_value_text16be")
   (macro sqlite3_value_type::int (sqlite3_value*) "sqlite3_value_type")
   (macro sqlite3_aggregate_context::void* (sqlite3_context* int) "sqlite3_aggregate_context")
   (macro sqlite3_user_data::void* (sqlite3_context*) "sqlite3_user_data")
   (macro sqlite3_get_auxdata::void* (sqlite3_context* int) "sqlite3_get_auxdata")
;   (macro sqlite3_set_auxdata::void (sqlite3_context* int void* *void*->void) "sqlite3_set_auxdata")
;   (macro sqlite3_result_blob::void (sqlite3_context* void* int *void*->void) "sqlite3_result_blob")
   (macro sqlite3_result_double::void (sqlite3_context* double) "sqlite3_result_double")
   (macro sqlite3_result_error::void (sqlite3_context* string int) "sqlite3_result_error")
;   (macro sqlite3_result_error16::void (sqlite3_context* void* int) "sqlite3_result_error16")
   (macro sqlite3_result_int::void (sqlite3_context* int) "sqlite3_result_int")
;   (macro sqlite3_result_int64::void (sqlite3_context* sqlite_int64) "sqlite3_result_int64")
   (macro sqlite3_result_null::void (sqlite3_context*) "sqlite3_result_null")
   (macro sqlite3_result_text::void (sqlite3_context* string int int) "sqlite3_result_text")
;   (macro sqlite3_result_text16::void (sqlite3_context* void* int *void*->void) "sqlite3_result_text16")
;   (macro sqlite3_result_text16le::void (sqlite3_context* void* int *void*->void) "sqlite3_result_text16le")
;   (macro sqlite3_result_text16be::void (sqlite3_context* void* int *void*->void) "sqlite3_result_text16be")
   (macro sqlite3_result_value::void (sqlite3_context* sqlite3_value*) "sqlite3_result_value")
;   (macro sqlite3_create_collation::int (sqlite3* string int void* *void*,int,void*,int,void*->int) "sqlite3_create_collation")
;   (macro sqlite3_create_collation16::int (sqlite3* string int void* *void*,int,void*,int,void*->int) "sqlite3_create_collation16")
;   (macro sqlite3_collation_needed::int (sqlite3* void* *void*,sqlite3*,int,string->void) "sqlite3_collation_needed")
;   (macro sqlite3_collation_needed16::int (sqlite3* void* *void*,sqlite3*,int,void*->void) "sqlite3_collation_needed16")
   (macro sqlite3_key::int (sqlite3* void* int) "sqlite3_key")
   (macro sqlite3_rekey::int (sqlite3* void* int) "sqlite3_rekey")
   (macro sqlite3_sleep::int (int) "sqlite3_sleep")
   (macro sqlite3_expired::int (sqlite3_stmt*) "sqlite3_expired")
   (macro sqlite3_global_recover::int () "sqlite3_global_recover")

;   (type char-array (array char) "char $[  ]")

;   (type sqlite3 s-sqlite3 "sqlite3")
   (type sqlite_int64 int "sqlite_int64")
   (type sqlite_uint64 uint "sqlite_uint64")
;   (type void*,int,string*,string*->int "int ($(void *,int,char **,char **))")

   ; this is no longer the "preferred" interface in sqlite3
   ;
;   (type *void*,int,string*,string*->int (function int (void* int string* string*))
;	 "int ((*$)(void *,int,char **,char **))")
;   (type sqlite3_callback *void*,int,string*,string*->int "sqlite3_callback")


   (type sqlite3* (opaque) "sqlite3*")
   (type sqlite3_stmt* (opaque) "sqlite3_stmt *")
   (type sqlite3_context* (opaque) "sqlite3_context *")
   (type sqlite3_value* (opaque) "sqlite3_value *")
   (type sqlite3_value** (pointer sqlite3_value*) "sqlite3_value **")

;   (type cbDef1 (function void (sqlite3_context* int sqlite3_value**)) "(*)(sqlite3_context*,int,sqlite3_value**)")
;   (type cbDef2 (function void (sqlite3_context*)) "(*)(sqlite3_context*)")
   
;   (type sqlite3 (opaque) "sqlite3")
;   (type sqlite3* (pointer sqlite3) "sqlite3*")
;   (type sqlite3_stmt (opaque) "sqlite3_stmt")
;   (type sqlite3_stmt* (pointer sqlite3_stmt) "sqlite3_stmt *")
;   (type sqlite3_context (opaque) "sqlite3_context")
;   (type sqlite3_context* (pointer sqlite3_context) "sqlite3_context *")   
;   (type sqlite3_value (opaque) "sqlite3_value")
;   (type sqlite3_value* (pointer sqlite3_value) "sqlite3_value *")   
   
;   (type sqlite3_stmt s-sqlite3_stmt "sqlite3_stmt")
;   (type sqlite3_context s-sqlite3_context "sqlite3_context")
;   (type s-Mem (struct) "struct Mem")


   ;    (type void->string "char *($(void))")
;    (type void->int "int ($(void))")
;    (type sqlite3*->int "int ($(sqlite3 *))")
;   (type sqlite3*,string,sqlite3_callback,void*,string*->int "int ($(sqlite3 *,char *,sqlite3_callback,void *,char **))")
;    (type sqlite3*->sqlite_int64 "sqlite_int64 ($(sqlite3 *))")
;    (type sqlite3*->void "void ($(sqlite3 *))")
;    (type string->int "int ($(char *))")
;    (type void*->int "int ($(void *))")
;    (type void*,int->int "int ($(void *,int))")
;    (type *void*,int->int (function int (void* int)) "int ((*$)(void *,int))")
;    (type sqlite3*,*void*,int->int,void*->int "int ($(sqlite3 *,int ((*)(void *,int)),void *))")
;    (type sqlite3*,int->int "int ($(sqlite3 *,int))")
    (type string** (pointer string*) "char ***")
    (type int* (pointer int) "int *")
;    (type sqlite3*,string,string**,int*,int*,string*->int "int ($(sqlite3 *,char *,char ***,int *,int *,char **))")
;    (type string*->void "void ($(char **))")
;    (type string,...string->string "char *($(char *,...))")
;   (type string,va_list->string "char *($(char *,va_list))")
;    (type string->void "void ($(char *))")
;    (type int,string,string,...string->string "char *($(int,char *,char *,...))")
;    (type void*,int,string,string,string,string->int "int ($(void *,int,char *,char *,char *,char *))")
;    (type *void*,int,string,string,string,string->int (function int (void* int string string string string)) "int ((*$)(void *,int,char *,char *,char *,char *))")
;    (type sqlite3*,*void*,int,string,string,string,string->int,void*->int "int ($(sqlite3 *,int ((*)(void *,int,char *,char *,char *,char *)),void *))")
;    (type void*,string->void "void ($(void *,char *))")
;    (type *void*,string->void (function void (void* string)) "void ((*$)(void *,char *))")
;    (type sqlite3*,*void*,string->void,void*->void* "void *($(sqlite3 *,void ((*)(void *,char *)),void *))")
;    (type *void*->int (function int (void*)) "int ((*$)(void *))")
;    (type sqlite3*,int,*void*->int,void*->void "void ($(sqlite3 *,int,int ((*)(void *)),void *))")
;    (type sqlite3*,*void*->int,void*->void* "void *($(sqlite3 *,int ((*)(void *)),void *))")
    (type sqlite3** (pointer sqlite3*) "sqlite3 **")
;    (type string,sqlite3**->int "int ($(char *,sqlite3 **))")
;    (type void*,sqlite3**->int "int ($(void *,sqlite3 **))")
;    (type sqlite3*->string "char *($(sqlite3 *))")
;    (type sqlite3*->void* "void *($(sqlite3 *))")
    (type sqlite3_stmt** (pointer sqlite3_stmt*) "sqlite3_stmt **")
;    (type sqlite3*,string,int,sqlite3_stmt**,string*->int "int ($(sqlite3 *,char *,int,sqlite3_stmt **,char **))")
;    (type void** (pointer void*) "void **")
;    (type sqlite3*,void*,int,sqlite3_stmt**,void**->int "int ($(sqlite3 *,void *,int,sqlite3_stmt **,void **))")
;    (type void*->void "void ($(void *))")
;    (type cb1 (opaque) "void ((*$)(void *))")
;    (type sqlite3_stmt*,int,void*,int,*void*->void->int "int ($(sqlite3_stmt *,int,void *,int,void ((*)(void *))))")
;    (type sqlite3_stmt*,int,double->int "int ($(sqlite3_stmt *,int,double))")
;    (type sqlite3_stmt*,int,int->int "int ($(sqlite3_stmt *,int,int))")
;    (type sqlite3_stmt*,int,sqlite_int64->int "int ($(sqlite3_stmt *,int,sqlite_int64))")
;    (type sqlite3_stmt*,int->int "int ($(sqlite3_stmt *,int))")
;    (type sqlite3_stmt*,int,string,int,*void*->void->int "int ($(sqlite3_stmt *,int,char *,int,void ((*)(void *))))")
;    (type sqlite3_stmt*,int,sqlite3_value*->int "int ($(sqlite3_stmt *,int,sqlite3_value *))")
;    (type sqlite3_stmt*->int "int ($(sqlite3_stmt *))")
;    (type sqlite3_stmt*,int->string "char *($(sqlite3_stmt *,int))")
;    (type sqlite3_stmt*,string->int "int ($(sqlite3_stmt *,char *))")
;    (type sqlite3_stmt*,int->void* "void *($(sqlite3_stmt *,int))")
;    (type sqlite3_stmt*,int->double "double ($(sqlite3_stmt *,int))")
;    (type sqlite3_stmt*,int->sqlite_int64 "sqlite_int64 ($(sqlite3_stmt *,int))")
    (type uchar* (pointer uchar) "unsigned char *")
;    (type sqlite3_stmt*,int->uchar* "unsigned char *($(sqlite3_stmt *,int))")

;    (type sqlite3_context*,int,sqlite3_value**->void "void ($(sqlite3_context *,int,sqlite3_value **))")
;    (type *sqlite3_context*,int,sqlite3_value**->void (function void (sqlite3_context* int sqlite3_value**)) "void ((*$)(sqlite3_context *,int,sqlite3_value **))")
;    (type sqlite3_context*->void "void ($(sqlite3_context *))")
;    (type *sqlite3_context*->void (function void (sqlite3_context*)) "void ((*$)(sqlite3_context *))")
;    (type sqlite3*,string,int,int,void*,*sqlite3_context*,int,sqlite3_value**->void,*sqlite3_context*,int,sqlite3_value**->void,*sqlite3_context*->void->int "int ($(sqlite3 *,char *,int,int,void *,void ((*)(sqlite3_context *,int,sqlite3_value **)),void ((*)(sqlite3_context *,int,sqlite3_value **)),void ((*)(sqlite3_context *))))")
;    (type sqlite3*,void*,int,int,void*,*sqlite3_context*,int,sqlite3_value**->void,*sqlite3_context*,int,sqlite3_value**->void,*sqlite3_context*->void->int "int ($(sqlite3 *,void *,int,int,void *,void ((*)(sqlite3_context *,int,sqlite3_value **)),void ((*)(sqlite3_context *,int,sqlite3_value **)),void ((*)(sqlite3_context *))))")
;    (type sqlite3_context*->int "int ($(sqlite3_context *))")
;    (type sqlite3_value*->void* "void *($(sqlite3_value *))")
;    (type sqlite3_value*->int "int ($(sqlite3_value *))")
;    (type sqlite3_value*->double "double ($(sqlite3_value *))")
;    (type sqlite3_value*->sqlite_int64 "sqlite_int64 ($(sqlite3_value *))")
;    (type sqlite3_value*->uchar* "unsigned char *($(sqlite3_value *))")
;    (type sqlite3_context*,int->void* "void *($(sqlite3_context *,int))")
;    (type sqlite3_context*->void* "void *($(sqlite3_context *))")
;    (type sqlite3_context*,int,void*,*void*->void->void "void ($(sqlite3_context *,int,void *,void ((*)(void *))))")
;    (type sqlite3_context*,void*,int,*void*->void->void "void ($(sqlite3_context *,void *,int,void ((*)(void *))))")
;    (type sqlite3_context*,double->void "void ($(sqlite3_context *,double))")
;    (type sqlite3_context*,string,int->void "void ($(sqlite3_context *,char *,int))")
;    (type sqlite3_context*,void*,int->void "void ($(sqlite3_context *,void *,int))")
;    (type sqlite3_context*,int->void "void ($(sqlite3_context *,int))")
;    (type sqlite3_context*,sqlite_int64->void "void ($(sqlite3_context *,sqlite_int64))")
;    (type sqlite3_context*,string,int,*void*->void->void "void ($(sqlite3_context *,char *,int,void ((*)(void *))))")
;    (type sqlite3_context*,sqlite3_value*->void "void ($(sqlite3_context *,sqlite3_value *))")
;    (type void*,int,void*,int,void*->int "int ($(void *,int,void *,int,void *))")
;    (type *void*,int,void*,int,void*->int (function int (void* int void* int void*)) "int ((*$)(void *,int,void *,int,void *))")
;    (type sqlite3*,string,int,void*,*void*,int,void*,int,void*->int->int "int ($(sqlite3 *,char *,int,void *,int ((*)(void *,int,void *,int,void *))))")
;    (type void*,sqlite3*,int,string->void "void ($(void *,sqlite3 *,int,char *))")
;    (type *void*,sqlite3*,int,string->void (function void (void* sqlite3* int string)) "void ((*$)(void *,sqlite3 *,int,char *))")
;    (type sqlite3*,void*,*void*,sqlite3*,int,string->void->int "int ($(sqlite3 *,void *,void ((*)(void *,sqlite3 *,int,char *))))")
;    (type void*,sqlite3*,int,void*->void "void ($(void *,sqlite3 *,int,void *))")
;    (type *void*,sqlite3*,int,void*->void (function void (void* sqlite3* int void*)) "void ((*$)(void *,sqlite3 *,int,void *))")
;    (type sqlite3*,void*,*void*,sqlite3*,int,void*->void->int "int ($(sqlite3 *,void *,void ((*)(void *,sqlite3 *,int,void *))))")
;    (type sqlite3*,void*,int->int "int ($(sqlite3 *,void *,int))")
;    (type int->int "int ($(int))")
;    (type ->int "int ($())")

   ))





