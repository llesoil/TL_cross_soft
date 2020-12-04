#!/bin/sh

numb='3019'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 5.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 40 --keyint 300 --lookahead-threads 4 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 4 --qpmax 69 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.3,1.4,5.0,0.4,0.6,0.2,0,1,12,40,300,4,20,0,5,4,69,48,3,2000,-1:-1,umh,show,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"