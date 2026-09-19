# FMS Link — board outputs.
#
#   make gerbers   plot gerbers + drill file into gerbers/
#   make zip       pack them flat for OSH Park
#   make images    re-render the README previews
#   make clean     remove generated outputs

BOARD   := fms-link.kicad_pcb
NAME    := fms-link
KICAD   := kicad-cli
GERBERS := gerbers
ZIP     := $(NAME)-gerbers.zip

LAYERS := F.Cu,B.Cu,F.SilkS,B.SilkS,F.Mask,B.Mask,Edge.Cuts

# The files OSH Park wants, in the archive, flat. The .gbrjob is deliberately
# left out — it is a manifest, not a layer.
PLOTS := \
	$(GERBERS)/$(NAME)-F_Cu.gtl \
	$(GERBERS)/$(NAME)-B_Cu.gbl \
	$(GERBERS)/$(NAME)-F_Mask.gts \
	$(GERBERS)/$(NAME)-B_Mask.gbs \
	$(GERBERS)/$(NAME)-F_Silkscreen.gto \
	$(GERBERS)/$(NAME)-B_Silkscreen.gbo \
	$(GERBERS)/$(NAME)-Edge_Cuts.gm1 \
	$(GERBERS)/$(NAME).drl

IMAGES := images/board-front.png images/board-back.png

.PHONY: all gerbers zip images clean

all: zip images

gerbers: $(PLOTS)

# One kicad-cli invocation plots every layer, so the whole set hangs off a
# single rule keyed on the drill file; the rest fall out of the same commands.
$(PLOTS): $(BOARD)
	$(KICAD) pcb export gerbers --output $(GERBERS)/ --layers "$(LAYERS)" $(BOARD)
	$(KICAD) pcb export drill --output $(GERBERS)/ --format excellon \
		--drill-origin absolute --excellon-units mm $(BOARD)

zip: $(ZIP)

# -j stores the files without their gerbers/ prefix: OSH Park rejects a zip
# with an enclosing folder.
$(ZIP): $(PLOTS)
	rm -f $@
	zip -j $@ $(PLOTS)

images: $(IMAGES)

# Rendered without the jack's 3D model, which would otherwise hide the board:
# pointing KIPRJMOD at an empty dir makes the model path unresolvable.
$(IMAGES): $(BOARD)
	@mkdir -p images
	$(eval NO3D := $(shell mktemp -d))
	$(KICAD) pcb render --side top -w 427 -h 750 --quality high \
		--background opaque -D KIPRJMOD=$(NO3D) \
		-o images/board-front.png $(BOARD)
	$(KICAD) pcb render --side bottom -w 427 -h 750 --quality high \
		--background opaque -D KIPRJMOD=$(NO3D) \
		-o images/board-back.png $(BOARD)
	@rmdir $(NO3D)

clean:
	rm -f $(PLOTS) $(GERBERS)/$(NAME)-job.gbrjob $(ZIP)
