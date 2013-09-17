def get_params(params_file)
    puts "Executing pipeline using parameters in #{params_file}"
    my_config = YAML.load_file(params_file)
    pathway = my_config["pathway"]["pathway_name"]
    puts "pathway:\n* #{pathway}"
    genes_file = "./params/pathways/#{pathway}.genes"
    puts "pathway defintion file:\n* #{genes_file}"
    populations = my_config["data"]["populations"]

    maf_cutoff = my_config["genotype_filtering"]["maf"]
    minGQ = my_config["genotype_filtering"]["minGQ"]
    minDP = my_config["genotype_filtering"]["minDP"]
    flank_size = my_config["data"]["flank_size"]

    report_windows_sizes = my_config["report_windows_sizes"]
#    puts "maf filter:\n* #{maf_cutoff}"
    return pathway, genes_file, populations, maf_cutoff, minGQ, minDP, report_windows_sizes, flank_size
end

#desc "get a list of genes"
def get_genes(genes_file) 
    genes_file_h = File.new(genes_file, 'r')
    genes = []
    genes_file_h.each do
        |line|
        fields = line.split()
        gene = fields[0]
        if gene != 'gene'
            if gene.match('^[^#]')
                genes.push(gene)
            end
        end
    end
    return genes
end

def call_system(command, taskname='(undefined task)', execute=true, verbose=true, showheader=true, options={})
#def call_system(command, taskname='(undefined task)', options={})
    # execute a command on the system
    # works as the ruby builtin system() function, but adds logging capability, and an option to print the command instead of executing it.
    opts = {
        :taskname => '(undefinede task)',
        :execute => true,
        :verbose => true,
        :showheader => true
    }.merge options

    puts "storing logging output to 'logs/whole_pipeline.log'"
#    puts command
    log = Logger.new('logs/whole_pipeline.log', 'weekly')
    log.debug(command)

    if verbose == true
        log.debug("\nExecuting command in task #{taskname} :\n  $: #{command}")
        puts("\nExecuting command in task #{taskname} :\n  $: #{command}")
    end

    if execute == true
        output = %x[#{command}]
        log.debug(output)
        puts output
    end

    puts taskname
    if taskname != "(undefined task)"
        if showheader == true
            puts "\nAttempting to print the first lines of the output file #{taskname}:\n"
            first_lines = %x["head" "-n3" #{taskname}]
            puts first_lines
            puts "\n"
            log.debug "\nAttempting to print the first lines of the output file:\n"
            log.debug(first_lines)
            log.debug "\n"
        end
    end
end

