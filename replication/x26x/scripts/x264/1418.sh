#!/bin/sh

numb='1419'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 15 --keyint 300 --lookahead-threads 3 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.3,1.3,2.6,0.5,0.7,0.3,2,0,14,15,300,3,22,30,4,1,62,18,6,1000,1:1,hex,show,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"