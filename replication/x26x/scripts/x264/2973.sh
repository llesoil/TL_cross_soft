#!/bin/sh

numb='2974'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 25 --keyint 220 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 2 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.4,1.0,0.6,0.6,0.8,0.1,3,1,8,25,220,3,29,10,5,2,69,38,6,2000,1:1,umh,show,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"