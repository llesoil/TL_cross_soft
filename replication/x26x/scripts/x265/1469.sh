#!/bin/sh

numb='1470'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 20 --keyint 210 --lookahead-threads 1 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.6,1.2,2.4,0.5,0.7,0.4,2,1,14,20,210,1,27,40,4,4,69,18,2,2000,-2:-2,hex,crop,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"