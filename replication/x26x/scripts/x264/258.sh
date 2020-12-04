#!/bin/sh

numb='259'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 3.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 10 --keyint 250 --lookahead-threads 3 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.1,1.1,3.0,0.3,0.6,0.1,3,0,0,10,250,3,26,30,4,3,64,18,2,2000,1:1,hex,show,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"