/*
	********************************************************
	*		Rudo Include v1.1                               *
	*		@author: Useful Funcitons for MySQL             *
	*		@latest update: 19.11.2011                      *
	*		Coded By DonatHan_Swift                         *
	*********************************************************
*/

stock sql_Int(sutun[], tablo[], kosul[], kosulsart[])
{
	new query[256], sonuc;
	format(query, sizeof(query), "SELECT `%s` FROM `%s` WHERE `%s` = '%s'", sutun, tablo, kosul, kosulsart);
	mysql_query(query);
	mysql_store_result();
	sonuc = mysql_fetch_int();
	mysql_free_result();
	return sonuc;
}

stock sql_Float(sutun[], tablo[], kosul[], kosulsart[])
{
	new query[256], Float:sonuc;
	format(query, sizeof(query), "SELECT `%s` FROM `%s` WHERE `%s` = '%s'", sutun, tablo, kosul, kosulsart);
	mysql_query(query);
	mysql_store_result();
	mysql_fetch_float(sonuc);
	mysql_free_result();
	return sonuc;
}

stock sql_Text(sutun[], tablo[], kosul[], kosulsart[])
{
	new query[256], sonuc;
	format(query, sizeof(query), "SELECT `%s` FROM `%s` WHERE `%s` = '%s'", sutun, tablo, kosul, kosulsart);
	mysql_query(query);
	mysql_store_result();
	if(mysql_fetch_row(sonuc) == 1)
	{ mysql_free_result(); }
	return sonuc;
}

stock sql_IntSet(tablo[], sutun[], setsutun, kosul[], kosulsart[])
{
	new query[256];
	format(query, sizeof(query), "UPDATE `%s` SET `%s` = '%i' WHERE `%s` = '%s'", tablo, sutun, setsutun, kosul, kosulsart);
	mysql_query(query);
}

stock sql_FloatSet(tablo[], sutun[], Float:setsutun, kosul[], kosulsart[])
{
	new query[256];
	format(query, sizeof(query), "UPDATE `%s` SET `%s` = '%f' WHERE `%s` = '%s'", tablo, sutun, setsutun, kosul, kosulsart);
	mysql_query(query);
}

stock sql_Set(tablo[], sutun[], setsutun[], kosul[], kosulsart[])
{
	new query[256];
	format(query, sizeof(query), "UPDATE `%s` SET `%s` = '%s' WHERE `%s` = '%s'", tablo, sutun, setsutun, kosul, kosulsart);
	mysql_query(query);
}

