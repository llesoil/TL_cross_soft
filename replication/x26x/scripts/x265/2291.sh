#!/bin/sh

numb='2292'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 30 --keyint 280 --lookahead-threads 3 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.4,1.0,0.4,0.3,0.6,0.2,1,2,6,30,280,3,29,50,3,2,66,28,6,2000,-2:-2,umh,show,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"