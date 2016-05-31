struct symrec {
	char *name; 			/* name of symbol */
	char *type; 			/* type of symbol */
	int used;				/* flag of use */
	struct symrec *next;	/* link field */
};

typedef struct symrec symrec;

symrec *sym_table = (symrec *)0;
symrec *putsym ();
symrec *getsym ();

symrec *putsym  (char *type_name, char *sym_name) {
	symrec *ptr;
	ptr = (symrec *) malloc (sizeof(symrec));
	ptr->name = (char *) malloc (strlen(sym_name)+1);
	strcpy(ptr->name, sym_name);
	strcpy(ptr->type, type_name);
	ptr->used = 0;
	ptr->next = (struct symrec *)sym_table;
	sym_table = ptr;
	return ptr;
}

symrec *getsym (char *sym_name) {
	symrec *ptr;
	for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *)ptr->next)
		if (strcmp (ptr->name,sym_name) == 0)
			return ptr;
	return 0;
}

