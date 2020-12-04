#!/bin/sh

numb='735'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 35 --keyint 210 --lookahead-threads 3 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.5,1.1,2.4,0.4,0.6,0.2,3,2,14,35,210,3,20,40,4,1,69,18,1,2000,1:1,umh,show,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"