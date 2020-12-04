#!/bin/sh

numb='2202'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 1.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 35 --keyint 290 --lookahead-threads 2 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.1,1.2,1.8,0.5,0.8,0.9,2,2,10,35,290,2,27,40,4,1,69,18,4,1000,-1:-1,umh,crop,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"