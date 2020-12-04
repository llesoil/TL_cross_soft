#!/bin/sh

numb='1328'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --intra-refresh --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 1.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 25 --keyint 300 --lookahead-threads 3 --min-keyint 25 --qp 30 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,None,--no-weightb,3.0,1.6,1.3,1.8,0.4,0.9,0.7,2,0,12,25,300,3,25,30,5,2,63,18,1,1000,1:1,hex,show,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"