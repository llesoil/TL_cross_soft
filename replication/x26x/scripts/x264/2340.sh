#!/bin/sh

numb='2341'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 35 --keyint 250 --lookahead-threads 3 --min-keyint 29 --qp 40 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.2,1.2,1.4,0.4,0.7,0.5,0,2,10,35,250,3,29,40,3,1,66,18,3,2000,-2:-2,hex,show,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"