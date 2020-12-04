#!/bin/sh

numb='643'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 0 --keyint 300 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.4,1.2,4.0,0.4,0.7,0.6,1,1,6,0,300,1,26,20,3,4,61,18,5,2000,-1:-1,umh,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"