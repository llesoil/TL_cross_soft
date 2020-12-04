#!/bin/sh

numb='1450'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 0 --keyint 210 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.0,1.3,4.0,0.2,0.8,0.8,2,0,6,0,210,0,23,30,5,3,64,48,4,2000,1:1,umh,show,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"