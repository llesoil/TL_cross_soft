#!/bin/sh

numb='2049'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.5,1.0,1.1,2.0,0.3,0.9,0.6,2,1,12,20,210,2,22,20,4,2,61,18,2,2000,1:1,umh,show,veryslow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"