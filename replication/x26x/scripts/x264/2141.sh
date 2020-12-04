#!/bin/sh

numb='2142'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 2.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 20 --keyint 250 --lookahead-threads 1 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.4,1.2,2.4,0.5,0.8,0.8,2,2,4,20,250,1,26,50,4,0,63,28,2,1000,-1:-1,hex,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"