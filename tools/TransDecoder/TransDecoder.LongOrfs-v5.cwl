class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  edam: 'http://edamontology.org/'
  s: 'http://schema.org/'
baseCommand:
  - TransDecoder.LongOrfs
inputs:
  - format: 'edam:format_3475'
    id: geneToTranscriptMap
    type: File?
    inputBinding:
      position: 0
      prefix: '--gene_trans_map'
    label: gene-to-transcript mapping
    doc: >-
      gene-to-transcript identifier mapping file (tab-delimited,
      gene_id<tab>trans_id<return>)
  - id: geneticCode
    type:
      - 'null'
      - type: enum
        symbols:
          - Euplotes
          - Tetrahymena
          - Candida
          - Acetabularia
          - Mitochondrial-Canonical
          - Mitochondrial-Vertebrates
          - Mitochondrial-Arthropods
          - Mitochondrial-Echinoderms
          - Mitochondrial-Molluscs
          - Mitochondrial-Ascidians
          - Mitochondrial-Nematodes
          - Mitochondrial-Platyhelminths
          - Mitochondrial-Yeasts
          - Mitochondrial-Euascomycetes
          - Mitochondrial-Protozoans
        name: geneticCode
    inputBinding:
      position: 0
      prefix: '-G'
    label: genetic code
    doc: >-
      genetic code (default: universal; see PerlDoc; options: Euplotes,
      Tetrahymena, Candida, Acetabularia)
  - id: minimumProteinLength
    type: int?
    inputBinding:
      position: 0
      prefix: '-m'
    label: minimum protein length
    doc: 'minimum protein length (default: 100)'
  - id: strandSpecific
    type: boolean?
    inputBinding:
      position: 0
      prefix: '-S'
    label: strand-specific
    doc: strand-specific (only analyzes top strand)
  - format: 'edam:format_1929'
    id: transcriptsFile
    type: File
    inputBinding:
      position: 0
      prefix: '-t'
    label: transcripts.fasta
    doc: FASTA formatted sequence file containing your transcripts.
outputs:
  - id: workingDir
    type: Directory
    outputBinding:
      glob: $(inputs.transcriptsFile.basename).transdecoder_dir
doc: >-
  TransDecoder identifies candidate coding regions within transcript sequences,
  such as those generated by de novo RNA-Seq transcript assembly using Trinity,
  or constructed based on RNA-Seq alignments to the genome using Tophat and
  Cufflinks.

  TransDecoder identifies likely coding sequences based on the following
  criteria:
        + a minimum length open reading frame (ORF) is found in a transcript sequence
        + a log-likelihood score similar to what is computed by the GeneID software is > 0.
        + the above coding score is greatest when the ORF is scored in the 1st reading frame
        as compared to scores in the other 2 forward reading frames.
        + if a candidate ORF is found fully encapsulated by the coordinates of another candidate ORF,
        the longer one is reported. However, a single transcript can report multiple ORFs
        (allowing for operons, chimeras, etc).
        + a PSSM is built/trained/used to refine the start codon prediction.
        + optional the putative peptide has a match to a Pfam domain above the noise cutoff score.

  Please visit https://github.com/TransDecoder/TransDecoder/wiki for full
  documentation.


  Releases can be downloaded from
  https://github.com/TransDecoder/TransDecoder/releases
label: >-
  TransDecoder.LongOrfs: Perl script, which extracts the long open reading
  frames
requirements:
# TODO: The following type definitions are not accepted by CWLEXEC
# TODO: CWLEXEC exits with "The field [SchemaType] is required by [type]."
#  - class: SchemaDefRequirement
#    types:
#      - name: genetic_codes
#        symbols:
#          - universal
#          - Euplotes
#          - Tetrahymena
#          - Candida
#          - Acetabularia
#          - Mitochondrial-Canonical
#          - Mitochondrial-Vertebrates
#          - Mitochondrial-Arthropods
#          - Mitochondrial-Echinoderms
#          - Mitochondrial-Molluscs
#          - Mitochondrial-Ascidians
#          - Mitochondrial-Nematodes
#          - Mitochondrial-Platyhelminths
#          - Mitochondrial-Yeasts
#          - Mitochondrial-Euascomycetes
#          - Mitochondrial-Protozoans
#        type: enum
  - class: ResourceRequirement
    coresMin: 2
    ramMin: 50
  - class: InlineJavascriptRequirement
hints:
  - class: DockerRequirement
    dockerPull: 'greatfireball/ime_transdecoder:5.0.2'
$schemas:
  - 'http://edamontology.org/EDAM_1.20.owl'
  - 'https://schema.org/docs/schema_org_rdfa.html'
's:author': Maxim Scheremetjew
's:copyrightHolder': 'EMBL - European Bioinformatics Institute, 2018'
's:license': 'https://www.apache.org/licenses/LICENSE-2.0'