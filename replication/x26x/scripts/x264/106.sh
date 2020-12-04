#!/bin/sh

numb='107'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 45 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.1,1.3,3.6,0.2,0.6,0.8,3,2,0,45,210,2,22,20,5,1,67,18,3,1000,-1:-1,hex,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"