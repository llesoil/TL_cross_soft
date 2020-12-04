#!/bin/sh

numb='839'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --no-asm --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 35 --keyint 260 --lookahead-threads 1 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,--no-asm,None,--weightb,0.5,1.0,1.3,4.0,0.3,0.7,0.5,0,0,8,35,260,1,29,20,5,1,62,28,1,1000,-2:-2,dia,crop,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"