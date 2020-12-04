#!/bin/sh

numb='481'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 25 --keyint 220 --lookahead-threads 1 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,0.5,1.5,1.0,4.6,0.2,0.8,0.8,1,2,0,25,220,1,21,10,4,0,62,28,6,1000,-2:-2,hex,show,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"