#!/bin/sh

numb='620'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 3.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 10 --keyint 290 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.6,1.0,3.4,0.6,0.6,0.6,2,1,4,10,290,1,27,10,5,0,66,18,5,2000,1:1,umh,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"