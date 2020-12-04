#!/bin/sh

numb='595'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 10 --keyint 260 --lookahead-threads 0 --min-keyint 20 --qp 20 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.6,1.2,1.4,0.3,0.9,0.5,2,0,2,10,260,0,20,20,4,0,65,18,3,2000,1:1,umh,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"