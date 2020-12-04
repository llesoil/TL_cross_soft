#!/bin/sh

numb='1810'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 0.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 20 --keyint 290 --lookahead-threads 0 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.5,1.3,0.8,0.6,0.8,0.6,1,2,10,20,290,0,29,10,4,3,65,38,1,1000,-2:-2,hex,show,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"