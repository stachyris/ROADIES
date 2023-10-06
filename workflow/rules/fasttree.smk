
rule fasttree:
	input:
		msa = config["OUT_DIR"]+"/genes/gene_{id}_filtered.fa.aln"
	output:
		gene_tree = config["OUT_DIR"]+"/genes/gene_{id}_filtered.fa.aln.treefile"
	params:
		m = config["MIN_ALIGN"],
		max_len = int(100*config["LENGTH"]/config["IDENTITY"])
	threads: 1
	benchmark:
		config["OUT_DIR"]+"/benchmarks/{id}.fasttree.txt"
	shell:
		'''
		if [[ `grep -n '>' {input.msa} | wc -l` -gt {params.m} ]] && [[ `awk 'BEGIN{{l=0;n=0;st=0}}{{if (substr($0,1,1) == ">") {{st=1}} else {{st=2}}; if(st==1) {{n+=1}} else if(st==2) {{l+=length($0)}}}} END{{if (n>0) {{print int((l+n-1)/n)}} else {{print 0}} }}' {input.msa}` -lt {params.max_len} ]]
		then
			FastTree -gtr -nt {input.msa} > {output}
		else
			touch {output.gene_tree}
		fi
		'''

rule mergeTrees:
	input:
		expand(config["OUT_DIR"]+"/genes/gene_{id}_filtered.fa.aln.treefile",id=IDS)
	output:
		config["OUT_DIR"]+"/genetrees/gene_tree_merged.nwk"
	params:
		msa_dir = config["OUT_DIR"]+"/genes",
	shell:
		'''
		cat {params.msa_dir}/*.treefile > {output}
		'''