#!/bin/sh

numb='2399'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 5 --keyint 260 --lookahead-threads 4 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.1,1.4,0.6,0.5,0.8,0.3,1,0,6,5,260,4,25,10,5,2,65,18,2,1000,-2:-2,umh,crop,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"