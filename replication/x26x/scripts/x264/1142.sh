#!/bin/sh

numb='1143'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 25 --keyint 270 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.2,1.2,0.8,0.6,0.8,0.8,3,1,16,25,270,4,28,0,4,3,60,48,2,1000,-1:-1,hex,crop,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"