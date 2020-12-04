#!/bin/sh

numb='1530'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 30 --keyint 290 --lookahead-threads 4 --min-keyint 29 --qp 50 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.5,1.2,0.6,0.4,0.7,0.0,1,2,4,30,290,4,29,50,5,0,64,38,2,1000,-1:-1,umh,show,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"