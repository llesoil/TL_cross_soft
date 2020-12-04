#!/bin/sh

numb='1002'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 20 --keyint 250 --lookahead-threads 2 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.5,1.2,2.0,0.3,0.7,0.6,3,1,4,20,250,2,29,10,4,0,69,28,5,2000,-1:-1,hex,show,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"